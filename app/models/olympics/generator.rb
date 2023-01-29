require 'csv'

class Olympics::Generator
  attr_accessor :teams, :games

  def self.generate_matchups(number_of_teams)
    teams = (1..number_of_teams).to_a
    generator = Olympics::Generator.new(teams)

    success = false
    1000.times do |i|
      next if success

      puts "Attempt #{i}"
      if generator.randomize_teams!
        success = true
        puts "\tSuccess"
      end
    end

    if success
      puts generator
      generator.write_to_file
    end
  end

  def initialize(teams)
    @teams = teams
    @num_teams = teams.length
    reset_games!
  end

  def sort_within_event(event_games)
    return event_games if event_games.nil?
    return event_games unless event_games.length == @num_teams

    first_game = event_games.shift
    second_game = event_games.find do |game|
      !(game.contains?(first_game.team_1) || game.contains?(first_game.team_2))
    end
    event_games.delete(second_game)

    next_team = (@teams - (first_game.teams + second_game.teams)).first
    third_game = event_games.find do |game|
      game.contains?(next_team)
    end
    event_games.delete(third_game)

    [first_game, second_game, third_game] + event_games
  end

  def to_s
    output = "*" * 80
    output += "\nOlympics"
    output += "\n\tteams: #{@num_teams}"
    output += "\n\tevents: #{Olympics::Match::Events::EVENTS.length}"
    output += "\n\tgames: #{@games.length}\n"
    output += "*" * 80
    output += "\n\n"
    grouped =  @games.group_by(&:event)
    Olympics::Match::Events::EVENTS.each do |event|
      event_matches = sort_within_event(grouped[event])
      (event_matches || []).each do |game|
        output += "#{game}\n"
      end
      output += "\n\n"
    end

    output
  end

  def event_count_for_team(team, event)
    @games.inject(0) do |acc, game|
      if game.contains?(team) && game.event == event
        acc + 1
      else
        acc
      end
    end
  end

  def assign_event_to_game(team, event)
    (0..@potential_games.length - 1).to_a.shuffle.each do |i|
      potential_game = @potential_games[i]
      next unless potential_game.contains?(team)

      other_team = potential_game.other_team(team)
      next unless event_count_for_team(other_team, event) < 2

      potential_game.event = event
      next if @games.include?(potential_game)

      @games << potential_game
      @potential_games.delete(potential_game)
      return
    end
  end

  def game_count(event)
    @games.inject(0) do |acc, game|
      game.event == event ? (acc + 1) : acc
    end
  end

  def valid?
    validation_errors = []

    Olympics::Match::Events::EVENTS.each do |event|
      count = game_count(event)
      if count > @num_teams
        validation_errors << "\tvalidation failure: There are #{count} #{event} games"
      end
    end

    @teams.each do |team|
      Olympics::Match::Events::EVENTS.each do |event|
        count = event_count_for_team(team, event)
        if count > 2
          validation_errors << "\tvalidation failure: Team #{team} has #{count} #{event} games"
        end
      end
    end

    unique_counts = games
      .filter { |g| g.event }
      .group_by { |g| g }.map{ |k, v| [k, v.length] }.to_h
    unique_counts.each do |matchup, count|
      if count > 1
        validation_errors << "\tvalidation failure: #{matchup} occurs #{count} times"
      end
    end

    if games.length == @num_teams * Olympics::Match::Events::EVENTS.length
      @teams.each do |team|
        @teams.each do |opponent|
          next if team > opponent

          unless @games.any? { |g| g.contains?(team) && g.contains?(opponent) }
            validation_errors << "\tvalidation failure: #{team} never plays #{opponent}"
          end
        end
      end
    end

    if validation_errors.length > 0
      # puts self
      puts validation_errors
    end

    validation_errors.length == 0
  end

  def reset_games!
    @games = []
    @potential_games = []
    teams.each do |team_1|
      teams.each do |team_2|
        if team_1 != team_2
          @potential_games << Game.new(team_1, team_2)
        end
      end
    end
  end

  def randomize_teams!
    failed = false

    reset_games!
    [1,2].each do |event_count_goal|
      next if failed

      Olympics::Match::Events::EVENTS.each do |event|
        next if failed

        @teams.shuffle.each do |team|
          next if failed

          existing_event_count = event_count_for_team(team, event)
          (event_count_goal - existing_event_count).times do
            assign_event_to_game(team, event)
          end

          if !valid?
            failed = true
          elsif event_count_for_team(team, event) < event_count_goal
            puts "\tfailed to assign enough games for #{team} in #{event}"
            failed = true
          end
        end
      end
    end

    !failed
  end

  def write_to_file
    bout_number = 0
    CSV.open("matchups.csv", "w") do |csv|
      grouped =  @games.group_by(&:event)
      Olympics::Match::Events::EVENTS.each do |event|
        event_matches = sort_within_event(grouped[event])
        event_matches.each do |game|
          csv << [bout_number += 1, game.team_1, game.team_2, game.event]
        end
      end
    end
  end

  class Game
    attr_accessor :event, :team_1, :team_2

    def initialize(team_1, team_2, event=nil)
      @event = event
      @team_1 = team_1 < team_2 ? team_1 : team_2
      @team_2 = team_1 < team_2 ? team_2 : team_1
    end

    def to_s
      "#{team_1} #{team_2} : #{event}"
    end

    def contains?(team)
      team_1 == team || team_2 == team
    end

    def teams
      [team_1, team_2]
    end

    def other_team(team)
      if team_1 == team
        team_2
      elsif team_2 == team
        team_1
      else
        raise "other_team(#{team}) called, game does not contain #{team}"
      end
    end

    def ==(other_game)
      return false if other_game.nil?

      teams = [team_1, team_2].sort
      other_teams = [other_game.team_1, other_game.team_2].sort

      teams == other_teams && event == other_game.event
    end

    def eql?(other)
      self == other
    end

    def hash
      to_s.hash
    end

    def dup
      Game.new(team_1, team_2, event)
    end
  end
end

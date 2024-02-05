require 'csv'

class Olympics::Generator
  attr_accessor :teams, :games

  def self.generate_matchups
    Olympics::Match.destroy_all
    team_numbers = (1..Olympics::Team.count).to_a
    generator = Olympics::Generator.new(team_numbers)

    success = false
    1000.times do |i|
      next if success

      puts "Attempt #{i}"
      if generator.randomize_teams!
        success = true
        puts "\tSuccess"
        generator.save_teams!
      end
    end

    if success
      generator
    else
      nil
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

    first_three = first_three_games(event_games)
    first_three.each { |game| event_games.delete(game) }

    teams_in_first_three = first_three.map(&:teams).flatten
    if teams_in_first_three.uniq.length == @num_teams
      first_three + event_games
    else
      missing_team = (@teams - teams_in_first_three).first
      next_game = event_games.find { |game| game.contains?(missing_team) }
      event_games.delete(next_game)

      first_three + [next_game] + event_games
    end
  end

  def first_three_games(event_games, target=nil)
    target ||= @num_teams
    result = nil

    event_games.each do |game_1|
      event_games.each do |game_2|
        next if game_1.overlaps_with?(game_2)

        event_games.each do |game_3|
          games = [game_1, game_2, game_3]
          teams = [
            game_1.team_1, game_1.team_2,
            game_2.team_1, game_2.team_2,
            game_3.team_1, game_3.team_2,
          ]

          if teams.uniq.length == target
            result = games
          end
        end
      end
    end

    result

    if result.nil?
      first_three_games(event_games, target - 1)
    else
      result
    end
  end

  def group_games!
    grouped = @games.group_by(&:event)
    @games = []
    Olympics::Match::Events::EVENTS.each do |event|
      sort_within_event(grouped[event]).each do |match|
        @games << match
      end
    end
  end

  def to_s
    output = ""
    grouped =  @games.group_by(&:event)
    Olympics::Match::Events::EVENTS.each do |event|
      event_matches = sort_within_event(grouped[event])
      (event_matches || []).each do |game|
        output += "#{game}<br/>"
      end
      output += "<br/><br/>"
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
          @potential_games << GeneratedMatch.new(team_1, team_2)
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

    unless failed
      group_games!
    end

    !failed
  end

  def save_teams!
    @games.each { |g| g.save! }
  end

  class GeneratedMatch
    attr_accessor :event, :team_1, :team_2

    def initialize(team_1, team_2, event=nil)
      @event = event
      @team_1 = team_1 < team_2 ? team_1 : team_2
      @team_2 = team_1 < team_2 ? team_2 : team_1
    end

    def to_s
      "#{team_1} #{team_2}"
    end

    def contains?(team)
      team_1 == team || team_2 == team
    end

    def overlaps_with?(other_game)
      contains?(other_game.team_1) || contains?(other_game.team_2)
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
      GeneratedMatch.new(team_1, team_2, event)
    end

    def save!
      current_bout_number = Olympics::Match.maximum(:bout_number) || 0
      Olympics::Match.create!(
        team_1: Olympics::Team.where(number: team_1).first!,
        team_2: Olympics::Team.where(number: team_2).first!,
        bout_number: current_bout_number + 1,
        event: event
      )
    end
  end
end

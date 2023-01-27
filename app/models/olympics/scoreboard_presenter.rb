module Olympics
  class ScoreboardPresenter
    def now_playing
      Match
        .order(:bout_number => "ASC")
        .where(:now_playing => true)
        .limit(2)
        .all
    end

    def on_deck(offset=0)
      Match
        .order(:bout_number => "ASC")
        .where(:winning_team_id => nil)
        .where(:now_playing => false)
        .offset(offset)
        .limit(2)
        .all
    end

    def in_the_hole
      on_deck(offset(2))
    end

    def results
      Match
        .order(:bout_number => "DESC")
        .where("winning_team_id is not null")
        .all
    end

    def tiebreaker_message(t1, t2)

      if t1.wins_over(t2) > t2.wins_over(t1)
        teams = [t1, t2]
      elsif t2.wins_over(t1) > t1.wins_over(t2)
        teams = [t2, t1]
      elsif t1.bp_cups > t2.bp_cups
        teams = [t1, t2]
      elsif t2.bp_cups > t1.bp_cups
        teams = [t2, t1]
      else
        teams = [t1, t2].sort_by(&:number)
        tiebreaker_message = "tied on both criteria: <br/> #{t1.wins_over(t2)}-#{t2.wins_over(t1)}<br/> BP cups: #{t1.bp_cups} to #{t2.bp_cups}"
      end

      tiebreaker_message = "#{teams[0].name} <br/>"
      tiebreaker_message += "#{teams[0].wins_over(teams[1])}-#{teams[1].wins_over(teams[0])} <br/>"
      if t1.wins_over(t2) == t2.wins_over(t1)
        tiebreaker_message += "BP cups: #{teams[0].bp_cups} to #{teams[1].bp_cups}"
      end

      [teams, tiebreaker_message]
    end

    def rankings
      rankings = []

      points_by_team = Match.group(:winning_team_id).size
      points_by_team.delete(nil)
      Team.all.map(&:id).each do |team_id|
        unless points_by_team.keys.include?(team_id)
          points_by_team[team_id] = 0
        end
      end


      rank = 1
      Team.count.times do
        next if points_by_team.length == 0

        # [points, [[:team_id, points], [:team_id, points]]]
        highest_scorers = points_by_team.group_by { |_, pts| pts }.max
        teams = highest_scorers[1].map { |tuple| Team.find(tuple[0]) }
        tiebreaker_message = nil

        if teams.length == 2
          teams, tiebreaker_message = tiebreaker_message(teams[0], teams[1])

          # puts "t1(#{t1.name}): #{t1.bp_cups}, t2(#{t2.name}): #{t2.bp_cups}"
        end

        if teams.length > 0
          rankings << {
            rank: rank,
            points: highest_scorers[0],
            teams: teams,
          }

          if tiebreaker_message
            rankings.last[:tiebreaker_message] = tiebreaker_message
          end

          teams.each { |team| points_by_team.delete(team.id) }
          rank += teams.length
        end
      end

      rankings
    end
  end
end

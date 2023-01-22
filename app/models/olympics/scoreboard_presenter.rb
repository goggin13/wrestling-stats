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

        if teams.length > 0
          rankings << {
            rank: rank,
            points: highest_scorers[0],
            teams: teams.sort_by(&:name)
          }

          teams.each { |team| points_by_team.delete(team.id) }
          rank += teams.length
        end
      end

      rankings
    end
  end
end

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
      tiebreaker_message = ""

      if t1.better_than?(t2)
        tiebreaker_message += "#{t1.name} <br/>"
      elsif t2.better_than?(t1)
        tiebreaker_message += "#{t2.name} <br/>"
      else
        tiebreaker_message = "tie<br/>"
      end

      tiebreaker_message += "#{t1.wins_over(t2)}-#{t2.wins_over(t1)} <br/>"
      if t1.wins_over(t2) == t2.wins_over(t1)
        tiebreaker_message += "BP cups: #{t1.bp_cups} to #{t2.bp_cups}"
      end

      tiebreaker_message
    end

    def rankings
      ranked_teams = Team.all.sort do |a,b|
        if a.better_than?(b)
          -1
        elsif b.better_than?(a)
          1
        else
          0
        end
      end

      i = 0
      rankings = []
      current_ranking = 1
      current_teams = []
      while i < ranked_teams.length do
        current_team = ranked_teams[i]
        current_teams << current_team
        next_teams = ranked_teams[i + 1..]

        if next_teams.empty? ||
            current_teams.all? { |t| t.better_than_all_of?(next_teams) }
          rankings << {
            rank: current_ranking,
            points: current_team.points,
            teams: current_teams.sort_by(&:name)
          }

          current_ranking += current_teams.length
          current_teams = []
        end

        i += 1
      end

      rankings
    end
  end
end
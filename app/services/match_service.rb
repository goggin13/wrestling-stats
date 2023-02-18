class MatchService
  def self.preview(away, home)
    home_data = home.wrestlers.inject({college: home}) do |acc, w|
      acc[w.weight] = w
      acc
    end

    away_data = away.wrestlers.inject({college: away} ) do |acc, w|
      acc[w.weight] = w
      acc
    end

    home_score = 0
    away_score = 0
    up_for_grabs_score = 0
    home_wins = 0
    away_wins = 0
    up_for_grabs_wins = 0
    WrestlerService::WEIGHTS.each do |weight|
      if home_data.has_key?(weight) && away_data.has_key?(weight)
        if home_data[weight].rank < away_data[weight].rank
          home_score += 3
          home_wins += 1
        else
          away_score += 3
          away_wins += 1
        end
      elsif home_data.has_key?(weight)
        home_score += 4
        home_wins += 1
      elsif away_data.has_key?(weight)
        away_score += 4
        away_wins += 1
      else
        up_for_grabs_wins += 1
      end
    end

    {
      home: home_data,
      away: away_data,
      prediction: {
        home: { score: home_score, wins: home_wins },
        away: { score: away_score, wins: away_wins },
        up_for_grabs: { score: up_for_grabs_wins * 3, wins: up_for_grabs_wins },
      }
    }
  end
end

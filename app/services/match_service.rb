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
    WrestlerService::WEIGHTS.each do |weight|
      if home_data.has_key?(weight) && away_data.has_key?(weight)
        if home_data[weight].rank < away_data[weight].rank
          home_score += 3
        else
          away_score += 3
        end
      elsif home_data.has_key?(weight)
        home_score += 4
      else
        away_score += 4
      end
    end

    {
      home: home_data,
      away: away_data,
      home_score: home_score,
      away_score: away_score
    }
  end
end

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

    {home: home_data, away: away_data}
  end

  def self.top_ten_matchups
    # \ff
  end
end

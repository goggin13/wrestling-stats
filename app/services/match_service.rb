class MatchService
  def self.preview(away_college_id, home_college_id)
    home = College.find(home_college_id)
    away = College.find(away_college_id)

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
end

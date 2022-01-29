class Match < ApplicationRecord
  belongs_to :home_team, class_name: "College", foreign_key: "home_team_id"
  belongs_to :away_team, class_name: "College", foreign_key: "away_team_id"

  TOP_MATCHUP_LIMIT = 15

  def top_matchups
    WrestlerService::WEIGHTS.inject([]) do |acc, weight|
      home_wrestler = home_team.wrestlers.find { |w| w.weight == weight }
      away_wrestler = away_team.wrestlers.find { |w| w.weight == weight }

      if home_wrestler.present? && away_wrestler.present? &&
          home_wrestler.rank.present? && away_wrestler.rank.present? &&
          home_wrestler.rank <= TOP_MATCHUP_LIMIT && away_wrestler.rank <= TOP_MATCHUP_LIMIT
        acc << [away_wrestler, home_wrestler]
      end

      acc
    end
  end

  def to_s
    "#{id} : #{away_team.name} @ #{home_team.name} (#{watch_on}, #{time}, #{date})"
  end
end

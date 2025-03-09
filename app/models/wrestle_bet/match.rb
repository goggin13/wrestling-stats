class WrestleBet::Match < ApplicationRecord
  belongs_to :home_wrestler, class_name: "WrestleBet::Wrestler", foreign_key: "home_wrestler_id"
  belongs_to :away_wrestler, class_name: "WrestleBet::Wrestler", foreign_key: "away_wrestler_id"
  belongs_to :tournament
  validates_presence_of :weight

  def title
    "#{weight} lbs: #{home_wrestler.name} (#{home_wrestler.college.name}) vs. #{away_wrestler.name} (#{away_wrestler.college.name})"
  end
end

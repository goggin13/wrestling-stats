class WrestleBet::Tournament < ApplicationRecord
  has_many :matches, class_name: "WrestleBet::Match", dependent: :destroy

  def current_match
    matches.where(home_score: nil, away_score: nil, started: true).first
  end
end

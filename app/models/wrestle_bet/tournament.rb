class WrestleBet::Tournament < ApplicationRecord
  has_many :matches, class_name: "WrestleBet::Match", dependent: :destroy

  def current_match
    matches.where(home_score: nil, away_score: nil, started: true).first
  end

  def started?
    matches
      .where(started: true)
      .or(matches.where.not(home_score: nil))
      .or(matches.where.not(away_score: nil))
      .count > 0
  end
end

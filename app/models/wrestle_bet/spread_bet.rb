class WrestleBet::SpreadBet < ApplicationRecord
  belongs_to :user
  belongs_to :match, class_name: "WrestleBet::Match"

  validates :wager, inclusion: { in: %w(home away),
    message: "%{value} is not a valid wager [home|away]" }

  def label
    name = if wager == "home"
      match.home_wrestler.name
    else
      match.away_wrestler.name
    end

    "Bet on #{name}"
  end

  def won?
    return false unless match.completed?

    if wager == "home" && match.spread < 0 # favored
      (match.home_score - match.away_score) > match.spread.abs
    elsif wager == "away" && match.spread < 0 # underdog
      (match.home_score - match.away_score) < match.spread.abs
    elsif wager == "home" && match.spread > 0 # underdog
      (match.away_score - match.home_score) < match.spread.abs
    elsif wager == "away" && match.spread > 0 # favorite
      (match.away_score - match.home_score) > match.spread.abs
    else
      raise "won? fall through"
    end
  end
end

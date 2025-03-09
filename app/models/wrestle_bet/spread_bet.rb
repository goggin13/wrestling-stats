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
end

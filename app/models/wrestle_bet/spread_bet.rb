class WrestleBet::SpreadBet < ApplicationRecord
  belongs_to :user
  belongs_to :match, class_name: "WrestleBet::Match"

  validates :wager, inclusion: { in: %w(home away),
    message: "%{value} is not a valid wager [home|away]" }
end

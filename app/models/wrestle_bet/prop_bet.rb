class WrestleBet::PropBet < ApplicationRecord
  belongs_to :user
  belongs_to :tournament

  validates :jesus, numericality: { only_integer: true }
  validates :exposure, numericality: { only_integer: true }
  validates :challenges, numericality: { only_integer: true }
end

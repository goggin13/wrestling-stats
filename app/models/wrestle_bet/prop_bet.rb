class WrestleBet::PropBet < ApplicationRecord
  belongs_to :user
  belongs_to :tournament

  validates :jesus, numericality: { only_integer: true }
  validates :exposure, numericality: { only_integer: true }
  validates :challenges, numericality: { only_integer: true }

  def won_jesus?
    winning_difference = tournament.winning_prop_bet_value(:jesus)
    my_difference = (tournament.jesus - jesus).abs

    my_difference == winning_difference
  end

  def won_exposure?
    winning_difference = tournament.winning_prop_bet_value(:exposure)
    my_difference = (tournament.exposure - exposure).abs

    my_difference == winning_difference
  end

  def won_challenges?
    winning_difference = tournament.winning_prop_bet_value(:challenges)
    my_difference = (tournament.challenges - challenges).abs

    my_difference == winning_difference
  end
end

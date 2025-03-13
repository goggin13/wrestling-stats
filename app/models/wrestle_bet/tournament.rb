class WrestleBet::Tournament < ApplicationRecord
  has_many :matches, class_name: "WrestleBet::Match", dependent: :destroy
  has_many :prop_bets, class_name: "WrestleBet::PropBet", dependent: :destroy

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

  def completed?
    matches
      .where(home_score: nil)
      .or(matches.where(away_score: nil))
      .count == 0
  end

  def _winning_prop_bet_values
    return @winning_prop_bet_values if defined?(@winning_prop_bet_values)

    prop_bet_differences = {
      jesus: [],
      exposure: [],
      challenges: [],
    }

    prop_bets.each do |prop_bet|
      j = (jesus - prop_bet.jesus).abs
      e = (exposure - prop_bet.exposure).abs
      c = (challenges - prop_bet.challenges).abs

      prop_bet_differences[:jesus] << j
      prop_bet_differences[:exposure] << e
      prop_bet_differences[:challenges] << c
    end

    @winning_prop_bet_values = {
      jesus: prop_bet_differences[:jesus].min,
      exposure: prop_bet_differences[:exposure].min,
      challenges: prop_bet_differences[:challenges].min,
    }
  end

  def weights
    matches.pluck(:weight).sort
  end

  def weight_is_completed?(weight)
    matches.where(weight: weight).first.completed?
  end

  def winning_prop_bet_value(type)
    _winning_prop_bet_values[type]
  end
end

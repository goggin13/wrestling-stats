class WrestleBet::Match < ApplicationRecord
  belongs_to :home_wrestler, class_name: "WrestleBet::Wrestler", foreign_key: "home_wrestler_id"
  belongs_to :away_wrestler, class_name: "WrestleBet::Wrestler", foreign_key: "away_wrestler_id"
  belongs_to :tournament
  has_many :bets, class_name: "WrestleBet::SpreadBet"
  validates_presence_of :weight

  def title
    "#{weight} lbs: #{home_wrestler.name} (#{home_wrestler.college.name}) vs. #{away_wrestler.name} (#{away_wrestler.college.name})"
  end

  def current_bet_for_user(user)
    bets.where(user_id: user.id).first
  end

  def completed?
    home_score.present? && away_score.present?
  end

  def open_for_betting?
    !started? && !completed?
  end

  def users_with_home_wagers
    bets.where(wager: "home").map(&:user)
  end

  def users_with_away_wagers
    bets.where(wager: "away").map(&:user)
  end
end

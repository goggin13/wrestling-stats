class WrestleBet::Match < ApplicationRecord
  belongs_to :home_wrestler, class_name: "WrestleBet::Wrestler", foreign_key: "home_wrestler_id"
  belongs_to :away_wrestler, class_name: "WrestleBet::Wrestler", foreign_key: "away_wrestler_id"
  belongs_to :tournament
  validates_presence_of :weight
end

class College < ApplicationRecord
  has_many :wrestlers
  has_many :home_matches, class_name: "Match", foreign_key: "home_team_id", dependent: :destroy
  has_many :away_matches, class_name: "Match", foreign_key: "away_team_id", dependent: :destroy
end

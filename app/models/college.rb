class College < ApplicationRecord
  has_many :wrestlers, -> { order("weight ASC") }
  has_many :home_matches, class_name: "Match", foreign_key: "home_team_id", dependent: :destroy
  has_many :away_matches, class_name: "Match", foreign_key: "away_team_id", dependent: :destroy

  def matches
    Match.where("home_team_id = :id OR away_team_id = :id", id: id).order(date: "ASC")
  end
end

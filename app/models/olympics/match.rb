class Olympics::Match < ApplicationRecord
  belongs_to :team_1, class_name: "Olympics::Team"
  belongs_to :team_2, class_name: "Olympics::Team"
  belongs_to :winning_team, class_name: "Olympics::Team", optional: true

  validates_presence_of :bout_number

  module Events
    EVENTS = [
      BEER_PONG = "beer_pong",
      FLIP_CUP = "flip_cup",
      QUARTERS = "quarters",
      DRINK_BALL = "drink_ball",
    ]
  end
end

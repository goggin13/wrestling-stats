class WrestleBet::Tournament < ApplicationRecord
  has_many :matches, class_name: "WrestleBet::Match", dependent: :destroy
end

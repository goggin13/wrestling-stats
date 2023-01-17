class Olympics::Team < ApplicationRecord
  validates_presence_of :name, :number
end

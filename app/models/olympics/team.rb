class Olympics::Team < ApplicationRecord
  validates_presence_of :name, :number

  def self.create_2023_teams
    Olympics::Team.destroy_all

    [
      [1, "Dan & Landon"],
      [2, "Pat & Kristen"],
      [3, "Eric & Goggin"],
      [4, "Jake & Olivia"],
      [5, "Erin & Diana & Kelly"]
    ].each do |team_data|
      Olympics::Team.create!(
        number: team_data[0],
        name: team_data[1],
      )
    end
  end
end

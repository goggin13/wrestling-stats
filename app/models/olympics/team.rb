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

  def wins_over(other_team)
    Olympics::Match
      .where("team_1_id in (?)", [self.id, other_team.id])
      .where("team_2_id in (?)", [self.id, other_team.id])
      .where(winning_team_id: self.id)
      .count
  end

  def bp_cups
    winning_cups = Olympics::Match
      .where(winning_team_id: self.id)
      .sum(:bp_cups_remaining)

    losing_cups = Olympics::Match
      .where("(team_1_id = :id or team_2_id = :id)", {id: self.id})
      .where("winning_team_id != ?", self.id)
      .sum(:bp_cups_remaining)

    winning_cups - losing_cups
  end

  def points
    Olympics::Match
      .where("winning_team_id = ?", self.id)
      .count
  end

  def better_than?(other_team)
    return true if self.points > other_team.points
    return false if self.points < other_team.points

    return true if self.wins_over(other_team) > other_team.wins_over(self)
    return false if self.wins_over(other_team) < other_team.wins_over(self)
    self.bp_cups > other_team.bp_cups
  end

  def better_than_all_of?(other_teams)
    other_teams.all? do |other_team|
      self.better_than?(other_team)
    end
  end
end

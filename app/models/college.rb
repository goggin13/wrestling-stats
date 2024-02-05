class College < ApplicationRecord
  has_many :wrestlers, -> { order("weight ASC") }
  has_many :home_matches, class_name: "Match", foreign_key: "home_team_id", dependent: :destroy
  has_many :away_matches, class_name: "Match", foreign_key: "away_team_id", dependent: :destroy

  EQUIVALENCIES = [
    # [Canonical, alias_1, alias_2, ...],
    ["UNI", "Northern Iowa"],
    ["App State", "Appalachian State"],
    ["ND State", "North Dakota State"],
    ["SD State", "South Dakota State"],
    ["OK State", "Oklahoma State"],
    ["SIUE", "SIU Edwardsville"],
    ["Penn", "Pennsylvania"],
  ].inject({}) do |acc, names|
    canonical = names[0]
    names[1..].each do |alternate|
      acc[alternate] = canonical
    end

    acc
  end

  def self.find_or_create_by_corrected_name(name)
    if EQUIVALENCIES.has_key?(name)
      puts "Correcting: #{name} => #{EQUIVALENCIES[name]}"
      name = EQUIVALENCIES[name]
    end

    College.find_or_create_by(name: name)
  end

  def self.find_by_corrected_name!(name)
    if EQUIVALENCIES.has_key?(name)
      puts "Correcting: #{name} => #{EQUIVALENCIES[name]}"
      name = EQUIVALENCIES[name]
    end

    college = College.find_by(name: name)
    unless college.present?
      raise "Unable to find college: '#{name}'"
    end

    college
  end

  def matches
    Match.where("home_team_id = :id OR away_team_id = :id", id: id).order(date: "ASC")
  end
end

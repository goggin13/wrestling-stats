require "csv"

module Olympics
  class MatchService
    def self.import_from_file(path)
			CSV.foreach(path, headers: false, col_sep: ",") do |row|
				bout_number = row[0]
				team_1_number = row[1]
				team_2_number = row[2]
				event = row[3]
        Match.create!(
          bout_number: row[0],
          team_1: Team.where(number: team_1_number).first!,
          team_2: Team.where(number: team_2_number).first!,
          event: event
        )
			end
    end
  end
end

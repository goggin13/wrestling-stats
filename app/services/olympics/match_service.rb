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

    def self.update(match, match_params)
      result = match.update(match_params)

      changing_winning_team_id = match_params.has_key?(:winning_team_id) &&
        match_params[:winning_team_id].present?

      if result && changing_winning_team_id
        match.update_attribute(:now_playing, false)
        advance_now_playing!
      end

      if result && match.winning_team_id.nil?
        match.update_attribute(:bp_cups_remaining, 0)
      end

      result
    end

    def self.advance_now_playing!
      next_match = Match.where("not now_playing")
        .where("winning_team_id is null")
        .order("bout_number asc")
        .first

      if next_match.present?
        next_match.update_attribute(:now_playing, true)
      end
    end
  end
end

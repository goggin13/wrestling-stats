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
        advance_now_playing!
      end

      if result && match.winning_team_id.nil?
        match.update_attribute(:bp_cups_remaining, 0)
      end

      result
    end

    def self.advance_now_playing!
      currently_playing_team_ids = Match
        .where("now_playing")
        .all
        .map { |match| [match.team_1.id, match.team_2.id] }
        .flatten

      unplayed_events = Match.where("winning_team_id is null").map(&:event).uniq

      remaining_events = unplayed_events.sort_by do |e|
        Olympics::Match::Events::EVENTS.index(e)
      end

      next_event = remaining_events.first

      next_match_query = Match
        .where("winning_team_id is null")
        .where("event = ?", next_event)
        .order("bout_number asc")

      if !currently_playing_team_ids.empty?
        next_match_query = next_match_query
          .where("team_1_id not in (?)", currently_playing_team_ids)
          .where("team_2_id not in (?)", currently_playing_team_ids)
      end

      next_match = next_match_query.first
      if next_match
        next_match.update_attribute(:now_playing, true)
      end
    end
  end
end

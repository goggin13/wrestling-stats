class Olympics::MatchesController < Olympics::ApplicationController
  before_action :set_match, only: %i[ update ]

  def index
    @now_playing = Olympics::Match
      .where("now_playing")
      .order(:bout_number)
      .all

    @open_matches = Olympics::Match
      .where("winning_team_id is null")
      .where("not now_playing")
      .order(:bout_number)
      .all

    @closed_matches = Olympics::Match
      .where("winning_team_id is not null")
      .order("bout_number DESC")
      .all
  end

  def update
    respond_to do |format|
      if Olympics::MatchService.update(@match, match_params)
        notice = "Match #{@match.bout_number} was successfully updated."
        format.html { redirect_to olympics_matches_url, notice: notice }
      else
        alert = "Failed to update match #{@match.bout_number}"
        format.html { redirect_to olympics_matches_url, alert: alert }
      end
    end
  end

  def set_match
    @match = Olympics::Match.find(params[:id])
  end

  def match_params
    params.require(:olympics_match).permit(:winning_team_id, :now_playing, :bp_cups_remaining)
  end
end

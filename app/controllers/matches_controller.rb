class MatchesController < ApplicationController
  def index
    @matches = Match.all.order(:date)
  end

  def preview
    match = Match.find(params[:match_id])
    @match_preview = MatchService.preview(match.away_team, match.home_team)
    @home = @match_preview[:home]
    @away = @match_preview[:away]
    render
  end
end

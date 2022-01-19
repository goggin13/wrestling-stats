class CollegesController < ApplicationController

  def index
    @colleges = College.order(:dual_rank).order(:tournament_rank).all
  end

  def preview
    @match_preview = MatchService.preview(params[:team_1], params[:team_2])
    @home = @match_preview[:home]
    @away = @match_preview[:away]
    render
  end

end

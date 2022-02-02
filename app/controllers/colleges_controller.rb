class CollegesController < ApplicationController

  def show
    @college = College.find(params[:id])
  end

  def index
    @last_updated_at = College
      .maximum("updated_at")
      .in_time_zone("Central Time (US & Canada)")
      .strftime("%Y-%m-%d %H:%M")
    @colleges = College.order(:dual_rank).order(:tournament_rank).all
  end

  def preview
    @match_preview = MatchService.preview(params[:team_1], params[:team_2])
    @home = @match_preview[:home]
    @away = @match_preview[:away]
    render
  end

end

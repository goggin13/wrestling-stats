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
end

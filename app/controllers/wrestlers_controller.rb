class WrestlersController < ApplicationController
  def individual_rankings
    @weight = params[:weight]
    @wrestlers = Wrestler.where(weight: params[:weight]).order(:rank).all
    @last_updated_at = Wrestler
      .maximum("updated_at")
      .in_time_zone("Central Time (US & Canada)")
      .strftime("%Y-%m-%d %H:%M")
    render
  end
end

class WrestlersController < ApplicationController
  def individual_rankings
    @wrestlers = Wrestler.where(weight: params[:weight]).order(:rank).all
    render
  end
end

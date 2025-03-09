class WrestleBet::TournamentsController < WrestleBet::ApplicationController
  skip_before_action :authenticate_admin!, only: [:betslip]
  before_action :authenticate_user!, only: [:betslip]

  def index
  end

  def betslip
    @tournament = WrestleBet::Tournament.find(params[:id])
    @matches = @tournament.matches
  end
end

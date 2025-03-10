class WrestleBet::TournamentsController < WrestleBet::ApplicationController
  skip_before_action :authenticate_admin!, only: [:betslip]
  before_action :authenticate_user!, only: [:betslip]

  def index
  end

  def betslip
    @tournament = WrestleBet::Tournament.find(params[:id])
    @matches = @tournament.matches.order("weight ASC")
  end

  def display
    @tournament = WrestleBet::Tournament.find(params[:id])
    @match = @tournament.current_match

    if @match.present?
      render
    else
      @leaderboard = WrestleBet::Leaderboard.new(@tournament)
      @rankings = @leaderboard.rankings
      render "leaderboard"
    end
  end
end

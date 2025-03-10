class WrestleBet::TournamentsController < WrestleBet::ApplicationController
  skip_before_action :authenticate_admin!, only: [:betslip]
  before_action :_authenticate_user_from_link, only: [:betslip]
  before_action :authenticate_user!, only: [:betslip]

  def index
  end

  def betslip
    @tournament = WrestleBet::Tournament.find(params[:id])
    @matches = @tournament.matches.order("weight ASC")
  end

  def user_links
    @tournament = WrestleBet::Tournament.find(params[:id])
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

  def _authenticate_user_from_link
    return if current_user.present?
    return unless params[:c].present?

    email = Base64.decode64(params[:c])
    user = User.where(email: email).first!
    sign_in(user)
  end
end

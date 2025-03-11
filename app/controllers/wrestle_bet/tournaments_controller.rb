class WrestleBet::TournamentsController < WrestleBet::ApplicationController
  skip_before_action :authenticate_admin!, only: [:betslip, :show, :scorecard]
  before_action :_authenticate_user_from_link, only: [:betslip]
  before_action :authenticate_user!, only: [:betslip, :scorecard]

  def index
  end

  def betslip
    @tournament = WrestleBet::Tournament.find(params[:id])
    @matches = @tournament.matches.order("weight ASC")
      .all
      .sort_by { |m| m.completed? ? 1 : 0 }

    @prop_bet = WrestleBet::PropBet.where(
      user_id: current_user.id,
      tournament_id: @tournament.id
    ).first

    unless @prop_bet.present?
      @prop_bet = WrestleBet::PropBet.new(tournament_id: @tournament.id)
    end
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
      @tournament = WrestleBet::Tournament.find(params[:id])
      @leaderboard = WrestleBet::Leaderboard.new(@tournament)
      render "scorecard"
    end
  end

  def show
    @tournament = WrestleBet::Tournament.find(params[:id])
    render json: @tournament.as_json(
      only: [:id, :jesus, :exposure, :challenges],
    ).merge(match_in_progress: @tournament.current_match.present?)
  end

  def update
    @tournament = WrestleBet::Tournament.find(params[:id])
    @tournament.jesus = params[:wrestle_bet_tournament][:jesus]
    @tournament.exposure = params[:wrestle_bet_tournament][:exposure]
    @tournament.challenges = params[:wrestle_bet_tournament][:challenges]
    @tournament.save!

    redirect_to wrestle_bet_matches_url, notice: "Updated"
  end

  def scorecard
    @tournament = WrestleBet::Tournament.find(params[:id])
    @leaderboard = WrestleBet::Leaderboard.new(@tournament)
  end

  def _authenticate_user_from_link
    return if current_user.present?
    return unless params[:c].present?

    email = Base64.decode64(params[:c])
    user = User.where(email: email).first!
    sign_in(user)
  end
end

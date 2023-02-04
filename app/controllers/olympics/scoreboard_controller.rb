class Olympics::ScoreboardController < Olympics::ApplicationController
  before_action :_set_presenter
  skip_before_action :authenticate_admin!, except: [:generate_form, :generate_brackets]

  def generate_form
  end

  def generate_brackets
    @matches = Olympics::Match.order(:bout_number).all
    if params[:password] == "2314@#!$"
      @generator = Olympics::Generator.generate_matchups
      @success = @generator.present?
    else
      flash.now[:alert] = "Incorrect password"
      @success = false
    end
  end

  def scoreboard
    render layout: "olympics/scoreboard"
  end

  def fetch_now_playing
    respond_to { |format| format.js }
  end

  def fetch_on_deck
    respond_to { |format| format.js }
  end

  def fetch_rankings
    respond_to { |format| format.js }
  end

  def fetch_tiebreaker
    respond_to { |format| format.js }
  end

  def fetch_latest_updated_at
    render json: {
      last_updated_at: Olympics::Match.order("updated_at DESC").first.updated_at.to_i,
      completed_games: Olympics::Match.where("winning_team_id is not null").count
    }
  end

  def _set_presenter
    @presenter = Olympics::ScoreboardPresenter.new
  end
end

class Olympics::ScoreboardController < Olympics::ApplicationController
  before_action :_set_presenter
  skip_before_action :authenticate_admin!

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

  def fetch_latest_updated_at
    render json: {
      last_updated_at: Olympics::Match.order("updated_at DESC").first.updated_at.to_i
    }
  end

  def _set_presenter
    @presenter = Olympics::ScoreboardPresenter.new
  end
end

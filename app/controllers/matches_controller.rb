class MatchesController < ApplicationController
  before_action :set_match, except: [:index]

  def index
    @lookback_window = if params.has_key?(:lookback_window)
      params[:lookback_window].to_i
    else
      2
    end
    today = Date.today.in_time_zone("Central Time (US & Canada)")

    @matches = Match
      .where("date >= ?", today - @lookback_window.days)
      .order(:date).order(:time).order(:watch_on)
      .all

    @limit_to_rank = params[:limit_to_rank].to_i
    if @limit_to_rank > 0
      @matches = @matches.filter do |match|
        (match.home_team.dual_rank || 100) <= @limit_to_rank &&
          (match.away_team.dual_rank || 100) <= @limit_to_rank
      end
    end
  end

  def edit
  end

  def update
    if @match.update(match_params)
      redirect_to @match, notice: "Match was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_match
      match_id = params[:id] || params[:match_id]
      @match = Match.find(match_id)
      @preview = MatchService.preview(@match.away_team, @match.home_team)
      @home = @preview[:home]
      @away = @preview[:away]
      @prediction = @preview[:prediction]
    end

    def match_params
      params.require(:match).permit(:time, :watch_on)
    end
end

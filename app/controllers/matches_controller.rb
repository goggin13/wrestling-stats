class MatchesController < ApplicationController
  before_action :set_match, except: [:index]

  def index
    @matches = Match
      .where("date >= ?", Date.today.in_time_zone("Central Time (US & Canada)") - 1.days)
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
      @match_preview = MatchService.preview(@match.away_team, @match.home_team)
      @home = @match_preview[:home]
      @away = @match_preview[:away]
    end

    def match_params
      params.require(:match).permit(:time, :watch_on)
    end
end

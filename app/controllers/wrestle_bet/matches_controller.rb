class WrestleBet::MatchesController < WrestleBet::ApplicationController
  before_action :set_wrestle_bet_match, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_admin!, only: [:show]

  # GET /wrestle_bet/matches or /wrestle_bet/matches.json
  def index
    @wrestle_bet_matches = WrestleBet::Match.order("weight ASC")
      .all
      .sort_by { |m| m.completed? ? 1 : 0 }

    @tournament = WrestleBet::Tournament.first!
  end

  # GET /wrestle_bet/matches/1 or /wrestle_bet/matches/1.json
  def show
    respond_to do |format|
      format.html { render  }
      format.json do
        render json: @wrestle_bet_match.as_json(
          only: [:id, :home_score, :away_score]
        )
      end
    end
  end

  # GET /wrestle_bet/matches/new
  def new
    @wrestle_bet_match = WrestleBet::Match.new
  end

  # GET /wrestle_bet/matches/1/edit
  def edit
  end

  # POST /wrestle_bet/matches or /wrestle_bet/matches.json
  def create
    @wrestle_bet_match = WrestleBet::Match.new(wrestle_bet_match_params)

    respond_to do |format|
      if @wrestle_bet_match.save
        format.html { redirect_to wrestle_bet_match_url(@wrestle_bet_match), notice: "Match was successfully created." }
        format.json { render :show, status: :created, location: @wrestle_bet_match }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wrestle_bet_match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wrestle_bet/matches/1 or /wrestle_bet/matches/1.json
  def update
    respond_to do |format|
      if @wrestle_bet_match.update(wrestle_bet_match_params)
        format.html { redirect_to wrestle_bet_matches_url, notice: "Match was successfully updated." }
        format.json { render :show, status: :ok, location: @wrestle_bet_match }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wrestle_bet_match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wrestle_bet/matches/1 or /wrestle_bet/matches/1.json
  def destroy
    @wrestle_bet_match.destroy

    respond_to do |format|
      format.html { redirect_to wrestle_bet_matches_url, notice: "Match was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wrestle_bet_match
      @wrestle_bet_match = WrestleBet::Match.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wrestle_bet_match_params
      params.require(:wrestle_bet_match).permit(:weight, :started, :home_wrestler_id, :away_wrestler_id, :home_score, :away_score, :tournament_id, :spread)
    end
end

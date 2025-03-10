class WrestleBet::SpreadBetsController < WrestleBet::ApplicationController
  skip_before_action :authenticate_admin!, only: [:create]
  before_action :authenticate_user!, only: [:create]

  before_action :set_wrestle_bet_spread_bet, only: %i[ show edit update destroy ]

  before_action :verify_match_has_not_started, only: %i[ create ]

  # GET /wrestle_bet/spread_bets or /wrestle_bet/spread_bets.json
  def index
    @wrestle_bet_spread_bets = WrestleBet::SpreadBet.all
  end

  # GET /wrestle_bet/spread_bets/1 or /wrestle_bet/spread_bets/1.json
  def show
  end

  # GET /wrestle_bet/spread_bets/new
  def new
    @wrestle_bet_spread_bet = WrestleBet::SpreadBet.new
  end

  # GET /wrestle_bet/spread_bets/1/edit
  def edit
  end

  # POST /wrestle_bet/spread_bets or /wrestle_bet/spread_bets.json
  def create
    @bet = WrestleBet::SpreadBet.new(wrestle_bet_spread_bet_params)
    @bet.user_id = current_user.id
    WrestleBet::SpreadBet.where(
      user_id: current_user.id,
      match_id: @bet.match_id,
    ).destroy_all

    respond_to do |format|
      if @bet.save
        format.html {
          redirect_to wrestle_bet_betslip_url(id: @bet.match.tournament_id),
          notice: "#{@bet.label} placed"
        }
        format.json { render :show, status: :created, location: @bet }
      else
        @bet.errors.each do |field, message|
          Rails.logger.info("Failed to save bet: #{field}-#{message}")
        end
        format.html {
          redirect_to wrestle_bet_betslip_url(id: @bet.match.tournament_id),
          alert: "failed to place bet"
        }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wrestle_bet/spread_bets/1 or /wrestle_bet/spread_bets/1.json
  def update
    respond_to do |format|
      if @wrestle_bet_spread_bet.update(wrestle_bet_spread_bet_params)
        format.html { redirect_to wrestle_bet_spread_bet_url(@wrestle_bet_spread_bet), notice: "Spread bet was successfully updated." }
        format.json { render :show, status: :ok, location: @wrestle_bet_spread_bet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wrestle_bet_spread_bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wrestle_bet/spread_bets/1 or /wrestle_bet/spread_bets/1.json
  def destroy
    @wrestle_bet_spread_bet.destroy

    respond_to do |format|
      format.html { redirect_to wrestle_bet_spread_bets_url, notice: "Spread bet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wrestle_bet_spread_bet
      @wrestle_bet_spread_bet = WrestleBet::SpreadBet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wrestle_bet_spread_bet_params
      params.require(:wrestle_bet_spread_bet).permit(:match_id, :wager)
    end

    def verify_match_has_not_started
      @match = WrestleBet::Match.find(wrestle_bet_spread_bet_params[:match_id])
      if @match.started?
          redirect_to wrestle_bet_betslip_url(id: @match.tournament_id),
            alert: "Match has already started"
      end
    end
end

class WrestleBet::PropBetsController < WrestleBet::ApplicationController
  skip_before_action :authenticate_admin!, only: [:create, :update]
  before_action :authenticate_user!, only: [:create, :update]
  before_action :set_wrestle_bet_prop_bet, only: %i[ show edit update destroy ]
  before_action :verify_tournament_has_not_started, only: %i[ create update ]

  # GET /wrestle_bet/prop_bets or /wrestle_bet/prop_bets.json
  def index
    @wrestle_bet_prop_bets = WrestleBet::PropBet.all
  end

  # GET /wrestle_bet/prop_bets/1 or /wrestle_bet/prop_bets/1.json
  def show
  end

  # POST /wrestle_bet/prop_bets or /wrestle_bet/prop_bets.json
  def create
    @bet = WrestleBet::PropBet.new(wrestle_bet_prop_bet_params)
    @bet.user_id = current_user.id
    WrestleBet::PropBet.where(
      user_id: current_user.id,
      tournament_id: @bet.tournament_id,
    ).destroy_all

    respond_to do |format|
      if @bet.save
        format.html {
          redirect_to wrestle_bet_betslip_url(id: @bet.tournament_id),
          notice: "Prop bets updated"
        }
        format.json { render :show, status: :created, location: @bet }
      else
        @bet.errors.each do |field, message|
          Rails.logger.info("Failed to save bet: #{field}-#{message}")
        end
        format.html {
          redirect_to wrestle_bet_betslip_url(id: @bet.tournament_id),
          alert: "failed to place bet"
        }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wrestle_bet/prop_bets/1 or /wrestle_bet/prop_bets/1.json
  def update
    respond_to do |format|
      if @wrestle_bet_prop_bet.update(wrestle_bet_prop_bet_params)
        format.html {
          redirect_to wrestle_bet_betslip_url(id: @wrestle_bet_prop_bet.tournament_id),
          notice: "Prop bets updated"
        }
        format.json { render :show, status: :ok, location: @wrestle_bet_prop_bet }
      else
        @wrestle_bet_prop_bet.errors.each do |field, message|
          Rails.logger.info("Failed to save bet: #{field}-#{message}")
        end
        format.html {
          redirect_to wrestle_bet_betslip_url(id: @wrestle_bet_prop_bet.tournament_id),
          alert: "failed to update prop bets"
        }
        format.json { render json: @wrestle_bet_prop_bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wrestle_bet/prop_bets/1 or /wrestle_bet/prop_bets/1.json
  def destroy
    @wrestle_bet_prop_bet.destroy

    respond_to do |format|
      format.html { redirect_to wrestle_bet_prop_bets_url, notice: "Prop bet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wrestle_bet_prop_bet
      @wrestle_bet_prop_bet = WrestleBet::PropBet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wrestle_bet_prop_bet_params
      params.require(:wrestle_bet_prop_bet).permit(:tournament_id, :jesus, :exposure, :challenges)
    end

    def verify_tournament_has_not_started
      @tournament = WrestleBet::Tournament.find(wrestle_bet_prop_bet_params[:tournament_id])
      if @tournament.started?
          redirect_to wrestle_bet_betslip_url(id: @tournament.id),
            alert: "Tournament has already started"
      end
    end
end

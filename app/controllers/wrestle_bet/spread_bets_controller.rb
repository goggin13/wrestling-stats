class WrestleBet::SpreadBetsController < WrestleBet::ApplicationController
  before_action :set_wrestle_bet_spread_bet, only: %i[ show edit update destroy ]

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
    @wrestle_bet_spread_bet = WrestleBet::SpreadBet.new(wrestle_bet_spread_bet_params)
    @wrestle_bet_spread_bet.user_id = current_user.id


    respond_to do |format|
      if @wrestle_bet_spread_bet.save
        format.html { redirect_to wrestle_bet_spread_bet_url(@wrestle_bet_spread_bet), notice: "Spread bet was successfully created." }
        format.json { render :show, status: :created, location: @wrestle_bet_spread_bet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wrestle_bet_spread_bet.errors, status: :unprocessable_entity }
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
end

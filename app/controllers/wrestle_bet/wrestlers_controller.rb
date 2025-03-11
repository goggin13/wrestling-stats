class WrestleBet::WrestlersController < WrestleBet::ApplicationController
  before_action :set_wrestle_bet_wrestler, only: %i[ show edit update destroy ]

  # GET /wrestle_bet/wrestlers or /wrestle_bet/wrestlers.json
  def index
    @wrestle_bet_wrestlers = WrestleBet::Wrestler.all
  end

  # GET /wrestle_bet/wrestlers/1 or /wrestle_bet/wrestlers/1.json
  def show
  end

  # GET /wrestle_bet/wrestlers/new
  def new
    @wrestle_bet_wrestler = WrestleBet::Wrestler.new
    @colleges = College.pluck(:name, :id)
  end

  # GET /wrestle_bet/wrestlers/1/edit
  def edit
    @colleges = College.pluck(:name, :id)
  end

  # POST /wrestle_bet/wrestlers or /wrestle_bet/wrestlers.json
  def create
    @wrestle_bet_wrestler = WrestleBet::Wrestler.new(wrestle_bet_wrestler_params)

    respond_to do |format|
      if @wrestle_bet_wrestler.save
        format.html { redirect_to wrestle_bet_wrestler_url(@wrestle_bet_wrestler), notice: "Wrestler was successfully created." }
        format.json { render :show, status: :created, location: @wrestle_bet_wrestler }
      else
        @colleges = College.pluck(:name, :id)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wrestle_bet_wrestler.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wrestle_bet/wrestlers/1 or /wrestle_bet/wrestlers/1.json
  def update
    respond_to do |format|
      if @wrestle_bet_wrestler.update(wrestle_bet_wrestler_params)
        format.html { redirect_to wrestle_bet_wrestler_url(@wrestle_bet_wrestler), notice: "Wrestler was successfully updated." }
        format.json { render :show, status: :ok, location: @wrestle_bet_wrestler }
      else
        @colleges = College.pluck(:name, :id)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wrestle_bet_wrestler.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wrestle_bet/wrestlers/1 or /wrestle_bet/wrestlers/1.json
  def destroy
    @wrestle_bet_wrestler.destroy

    respond_to do |format|
      format.html { redirect_to wrestle_bet_wrestlers_url, notice: "Wrestler was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wrestle_bet_wrestler
      @wrestle_bet_wrestler = WrestleBet::Wrestler.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wrestle_bet_wrestler_params
      params.require(:wrestle_bet_wrestler).permit(:name, :college_id, :avatar)
    end
end

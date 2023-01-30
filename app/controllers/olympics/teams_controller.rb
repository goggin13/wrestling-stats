class Olympics::TeamsController < Olympics::ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /olympics/teams or /olympics/teams.json
  def index
    @teams = Olympics::Team.order(:number).all
  end

  # GET /olympics/teams/1 or /olympics/teams/1.json
  def show
  end

  # GET /olympics/teams/new
  def new
    @team = Olympics::Team.new
  end

  # GET /olympics/teams/1/edit
  def edit
  end

  # POST /olympics/teams or /olympics/teams.json
  def create
    @team = Olympics::Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to olympics_team_url(@team), notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /olympics/teams/1 or /olympics/teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to olympics_team_url(@team), notice: "Team was successfully updated." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /olympics/teams/1 or /olympics/teams/1.json
  def destroy
    @team.destroy

    respond_to do |format|
      format.html { redirect_to olympics_teams_url, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Olympics::Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:olympics_team).permit(:name, :number, :color)
    end
end

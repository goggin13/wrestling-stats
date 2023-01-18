class Olympics::MatchesController < Olympics::ApplicationController
  def scoreboard
    @teams = Olympics::Team.all
    @matches = Olympics::Match.all
    render layout: "olympics/scoreboard"
  end
end

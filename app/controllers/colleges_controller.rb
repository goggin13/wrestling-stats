class CollegesController < ApplicationController

  def preview_form
    @colleges = College.order(:name).all
    @college_names_map = @colleges.map { |c| [c.name, c.id] }
  end

  def preview
    @match_preview = MatchService.preview(params[:team_1], params[:team_2])
    @home = @match_preview[:home]
    @away = @match_preview[:away]
    render
  end

end

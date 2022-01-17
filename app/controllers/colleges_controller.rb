class CollegesController < ApplicationController
  before_action :set_college_names

  def preview_form
  end

  def preview
    @match_preview = MatchService.preview(params[:team_1], params[:team_2])
    @home = @match_preview[:home]
    @away = @match_preview[:away]
    render
  end

  def set_college_names
    colleges = College.order(:name).all
    @college_names_map = colleges.map { |c| [c.name, c.id] }
  end

end

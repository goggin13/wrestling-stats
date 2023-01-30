module Olympics::TeamHelper
  def with_team_color(team, element, &block)
    content = capture(&block)
    content_tag(element, content, :style => "color: #{team.color}")
  end

  def with_team_bg_color(team, element, &block)
    content = capture(&block)
    content_tag(element, content, :style => "background-color: #{team.color}")
  end
end

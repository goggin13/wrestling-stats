module Olympics::TeamHelper
  def with_team_color(team, element, &block)
    content = capture(&block)
    content_tag(element, content, :style => "color: #{team.color}")
  end

  def with_team_bg_color(team, element, &block)
    content = capture(&block)
    content_tag(element, content, :style => "background-color: #{team.color}")
  end

  def team_bg_color(team)
    "style=\"background-color: #{team.color}\"".html_safe
  end

  def team_name_brs(team)
    if team.name.scan(/&/).length == 1
      team.name.gsub("&", "<br/>&<br/>").html_safe
    else
      team.name.gsub("&", "<br/>&").html_safe
    end
  end
end

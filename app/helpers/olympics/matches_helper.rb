module Olympics::MatchesHelper
  def event_logo(match, options={})
    image_name = case match.event
    when Olympics::Match::Events::BEER_PONG
      "beer_pong.jpeg"
    when Olympics::Match::Events::FLIP_CUP
      "flip_cup.png"
    when Olympics::Match::Events::QUARTERS
      "quarter.png"
    when Olympics::Match::Events::DRINK_BALL
      "drink_ball.png"
    else
      raise "no event #{match.event} found in event_logo()"
    end

    options = {class: "event_logo"}
    image_tag "olympics/#{image_name}", options
  end

  def bp_cup_diff(match, team)
    return "" if match.winning_team_id.nil?
    return "" unless match.event == Olympics::Match::Events::BEER_PONG

    diff = if match.winning_team == team
      "+#{match.bp_cups_remaining}"
    else
      "-#{match.bp_cups_remaining}"
    end

    "<br/>#{diff}".html_safe
  end
end

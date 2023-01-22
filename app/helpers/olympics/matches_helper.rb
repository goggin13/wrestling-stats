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
      "drink_ball"
    else
      raise "no event #{match.event} found in event_logo()"
    end

    options = {class: "event_logo"}
    image_tag "olympics/#{image_name}", options
  end
end

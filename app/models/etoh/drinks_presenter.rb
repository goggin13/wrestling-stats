class Etoh::DrinksPresenter
  def initialize
    @drinks = Etoh::Drink
      .where("consumed_at > ?", Time.now.advance(hours: -12))
  end

  def current_drinks
    @drinks.count
  end

  def session_start
    @drinks.map(&:consumed_at).min
  end

  def session_length
    if session_start.present?
      ((Time.now - session_start) /  1.hour)
    else
      0
    end
  end

  def session_hours
    session_length.floor
  end

  def drinks_remaining
    [
      5 - current_drinks + session_hours,
      5,
    ].min
  end
end

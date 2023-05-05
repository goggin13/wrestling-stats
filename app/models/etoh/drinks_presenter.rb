class Etoh::DrinksPresenter
  LIMIT = 5
  attr_reader :drinks

  def initialize
    @drinks = Etoh::Drink
      .where("consumed_at > ?", Time.now.advance(hours: -12))
      .order("consumed_at DESC")
  end

  def current_drinks
    @drinks.count
  end

  def session_start
    @drinks.map(&:consumed_at).min
  end

  def session_last_metabolized_at
    @drinks.map(&:metabolized_at).compact.min || 0
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

  def recharge_in
    return 0 if @drinks.length == 0

    if session_last_metabolized_at == 0
      60 - ((Time.now - session_start) /  1.minute).round
    else
      60 - ((Time.now - session_last_metabolized_at) / 1.minutes).round
    end
  end

  def non_metabolized_drinks
    @drinks.reject { |drink| drink.metabolized? }
  end

  def drinks_remaining
    LIMIT - non_metabolized_drinks.length
  end
end

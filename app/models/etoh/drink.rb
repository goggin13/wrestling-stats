class Etoh::Drink < ApplicationRecord
  def self.metabolize!
    return unless can_metabolize?

    eligible = Etoh::Drink
      .where(metabolized_at: nil)
      .where("consumed_at < ?", Time.now.advance(minutes: -60))
      .order("consumed_at ASC")
      .first

    return unless eligible.present?

    metabolized_time = if last_metabolized_at == 0
      eligible.consumed_at + 60.minutes
    else
      [
        last_metabolized_at + 60.minutes,
        eligible.consumed_at + 60.minutes
      ].max
    end
    eligible.update_attribute(:metabolized_at, metabolized_time)

    Rails.logger.info "[METABOLIZE] metabolized #{eligible}"

    metabolize! if can_metabolize?
  end

  def self.last_metabolized_at
    Etoh::Drink.maximum(:metabolized_at) || 0
  end

  def self.can_metabolize?
    (Time.now - last_metabolized_at) > 60.minutes
  end

  def metabolized?
    metabolized_at.present?
  end
end

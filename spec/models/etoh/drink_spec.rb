require 'rails_helper'

RSpec.describe Etoh::Drink, type: :model do
  describe "self.metabolize!" do
    it "marks the oldest non metabolized drink as metabolized" do
      drink = FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -91))

      Etoh::Drink.metabolize!

      drink.reload
      expected_time = Time.now.advance(minutes: -31)
      expect(drink.metabolized_at).to be_present
      expect(drink.metabolized_at).to be > expected_time.advance(seconds: -1)
      expect(drink.metabolized_at).to be < expected_time.advance(seconds: 1)
    end

    it "doesn't mark a drink metabolized until 60 minutes after consumed" do
      drink = FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -30))

      Etoh::Drink.metabolize!

      drink.reload
      expect(drink.metabolized_at).to be_nil
    end

    it "doesn't metabolize more than one drink per houir" do
      drink_one = FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -61),
        metabolized_at: Time.now.advance(minutes: -1))

      drink_two = FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -61))

      Etoh::Drink.metabolize!

      drink_two.reload
      expect(drink_two.metabolized_at).to be_nil
    end

    it "sets metabolized to 60m after drink was consumed" do
      FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -121),
        metabolized_at: Time.now.advance(minutes: -61))
      drink = FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -121))

      Etoh::Drink.metabolize!

      drink.reload
      expected_time = Time.now.advance(minutes: -1)
      expect(drink.metabolized_at).to be_present
      expect(drink.metabolized_at).to be > expected_time.advance(seconds: -1)
      expect(drink.metabolized_at).to be < expected_time.advance(seconds: 1)
    end
  end

  describe "can_metabolize?" do
    it "is true if it has metabolized more than an hour ago" do
      FactoryBot.create(:etoh_drink,
        metabolized_at: Time.now.advance(minutes: -61))

      expect(Etoh::Drink.can_metabolize?).to eq(true)
    end

    it "is true when no drinks have been metabolized" do
      FactoryBot.create(:etoh_drink)

      expect(Etoh::Drink.can_metabolize?).to eq(true)
    end

    it "is false if it has metabolized less than an hour ago" do
      FactoryBot.create(:etoh_drink,
        metabolized_at: Time.now.advance(minutes: -59))

      expect(Etoh::Drink.can_metabolize?).to eq(false)
    end
  end
end

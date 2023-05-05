require 'rails_helper'

RSpec.describe Etoh::DrinksPresenter, type: :model do
  describe "current_drinks" do
    it "returns drinks consumed in the last 18 hours" do
      [
        Time.now.advance(hours: -13),
        Time.now.advance(hours: -11),
        Time.now,
      ].each do |consumed_at|
        FactoryBot.create(:etoh_drink, consumed_at: consumed_at)
      end

      presenter = Etoh::DrinksPresenter.new
      expect(presenter.current_drinks).to eq(2)
    end
  end

  describe "session_length" do
    it "number of hours since first drink this session" do
      [
        Time.now.advance(hours: -24),
        Time.now.advance(hours: -11),
        Time.now,
      ].each do |consumed_at|
        FactoryBot.create(:etoh_drink, consumed_at: consumed_at)
      end

      presenter = Etoh::DrinksPresenter.new
      expect(presenter.session_length.round).to eq(11)
    end

    it "returns zero for new session" do
      presenter = Etoh::DrinksPresenter.new
      expect(presenter.session_length).to eq(0)
    end
  end

  describe "drinks_remaining" do
    it "returns 5 for an empty session" do
      presenter = Etoh::DrinksPresenter.new
      expect(presenter.drinks_remaining).to eq(5)
    end

    it "returns 5 if a drink was consumed more than an hour ago" do
      FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -90),
        metabolized_at: Time.now.advance(minutes: -30))

      presenter = Etoh::DrinksPresenter.new
      expect(presenter.drinks_remaining).to eq(5)
    end

    it "returns zero if 5 drinks have been consumed in an hour" do
      5.times { FactoryBot.create(:etoh_drink) }
      presenter = Etoh::DrinksPresenter.new
      expect(presenter.drinks_remaining).to eq(0)
    end

    it "returns the difference between limit and metabolized drinks" do
      FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -121),
        metabolized_at: Time.now.advance(minutes: -61))
      FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -121),
        metabolized_at: Time.now.advance(minutes: -1))

      3.times { FactoryBot.create(:etoh_drink) }

      presenter = Etoh::DrinksPresenter.new
      expect(presenter.drinks_remaining).to eq(2)
    end

    it "can be negative" do
      8.times { FactoryBot.create(:etoh_drink, consumed_at: Time.now) }

      presenter = Etoh::DrinksPresenter.new

      expect(presenter.drinks_remaining).to eq(-3)
    end
  end

  describe "recharge_in" do
    it "returns the time until next drink can be metabolized" do
      FactoryBot.create(:etoh_drink,
                        consumed_at: Time.now.advance(minutes: -30))

      presenter = Etoh::DrinksPresenter.new

      expect(presenter.recharge_in).to eq(30)
    end

    it "returns the time until next drink can be metabolized" do
      FactoryBot.create(:etoh_drink,
        consumed_at: Time.now.advance(minutes: -61),
        metabolized_at: Time.now.advance(minutes: -1))
      FactoryBot.create(:etoh_drink,
                        consumed_at: Time.now.advance(minutes: -61))

      presenter = Etoh::DrinksPresenter.new

      expect(presenter.recharge_in).to eq(59)
    end

    it "is zero for no drinks" do
      presenter = Etoh::DrinksPresenter.new

      expect(presenter.recharge_in).to eq(0)
    end
  end
end

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
      FactoryBot.create(:etoh_drink, consumed_at: Time.now.advance(minutes: -90))
      presenter = Etoh::DrinksPresenter.new
      expect(presenter.drinks_remaining).to eq(5)
    end

    it "returns zero if 5 drinks have been consumed in an hour" do
      5.times { FactoryBot.create(:etoh_drink) }
      presenter = Etoh::DrinksPresenter.new
      expect(presenter.drinks_remaining).to eq(0)
    end

    it "returns the difference between drinks consumed and hours in session + 5" do
      5.times { FactoryBot.create(:etoh_drink, consumed_at: Time.now.advance(minutes: -125)) }
      presenter = Etoh::DrinksPresenter.new
      expect(presenter.drinks_remaining).to eq(2)
    end

    it "is negative" do
      5.times { FactoryBot.create(:etoh_drink, consumed_at: Time.now.advance(minutes: -125)) }
      3.times { FactoryBot.create(:etoh_drink, consumed_at: Time.now) }

      presenter = Etoh::DrinksPresenter.new

      expect(presenter.drinks_remaining).to eq(-1)
    end
  end
end

require "rails_helper"

feature "Etoh::Drinks page" do
  scenario "redirects with an error message if no user is logged in" do
    visit "/etoh/drinks"
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  scenario "clicking the button logs a drink" do
    sign_in FactoryBot.create(:user, :admin)
    visit "/etoh/drinks"
    expect do
      click_button "Drank drink"
    end.to change(Etoh::Drink,:count).by(1)

    drink = Etoh::Drink.last!

    expect(drink.oz).to eq(12)
    expect(drink.abv).to eq(5)
    expect(drink.consumed_at).to be_present
    expect(page).to have_content("Drink logged")
  end

  scenario "clicking the button logs an older drink" do
    sign_in FactoryBot.create(:user, :admin)
    visit "/etoh/drinks"
    expect do
      click_button "Drank drink (-15m)"
    end.to change(Etoh::Drink,:count).by(1)

    drink = Etoh::Drink.last!

    expect(drink.consumed_at).to be < Time.now.advance(minutes:-14)
    expect(drink.consumed_at).to be > Time.now.advance(minutes:-16)
  end

  scenario "viewing previous drinks" do
    times = [
      Time.now.advance(minutes: -10),
      Time.now.advance(minutes: -10),
      Time.now.advance(minutes: -10),
    ]

    times.each do |consumed_at|
      FactoryBot.create(:etoh_drink, consumed_at: consumed_at)
    end

    sign_in FactoryBot.create(:user, :admin)
    visit "/etoh/drinks"

    times.map do |t|
      t.in_time_zone('US/Central').strftime("%H:%M")
    end.each do |consumed_at|
      expect(page).to have_content("Drink logged #{consumed_at}")
    end
  end
end

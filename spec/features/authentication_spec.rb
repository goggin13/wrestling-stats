require "rails_helper"

feature "Authentication" do
  scenario "redirects with an error message if no user is logged in" do
    visit "/"
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  scenario "redirects with an error message if a non admin user is logged in" do
    sign_in FactoryBot.create(:user)
    visit "/"
    expect(page).to have_content("Please authenticate as an admin.")
    expect(page).to have_content("Access Denied")
  end

  scenario "allows an admin to view the home page" do
    sign_in FactoryBot.create(:user, :admin)
    visit "/"
    expect(page).to have_content("All Matchups")
  end
end

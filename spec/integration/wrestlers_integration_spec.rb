require "rails_helper"

RSpec.describe WrestlersController, :type => :controller do
  render_views

  before do
    FactoryBot.create(:wrestler,
      name: "Nick Suriano",
      rank: 1,
      college: "Michigan"
    )
    FactoryBot.create(:wrestler,
      name: "Vito Arujau",
      rank: 2,
      college: "Cornell"
    )
  end

  xit "can see the rankings" do
    get "/individual_rankings/125"

    expect(page).to have_css( "td", text: "Nick Suriano")
    expect(page).to have_css( "td", text: "1")
    expect(page).to have_css( "td", text: "Michigan")
    expect(page).to have_css( "td", text: "Vito Arujau")
    expect(page).to have_css( "td", text: "Cornell")
    expect(page).to have_css( "td", text: "2")
  end
end

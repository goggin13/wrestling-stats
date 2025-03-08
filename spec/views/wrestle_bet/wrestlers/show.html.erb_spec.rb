require 'rails_helper'

RSpec.describe "wrestle_bet/wrestlers/show", type: :view do
  before(:each) do
    @wrestle_bet_wrestler = assign(:wrestle_bet_wrestler, WrestleBet::Wrestler.create!(
      name: "Name",
      college: FactoryBot.create(:college, name: "Cornell")
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Cornell/)
  end
end

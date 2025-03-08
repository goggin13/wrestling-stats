require 'rails_helper'

RSpec.describe "wrestle_bet/wrestlers/index", type: :view do
  before(:each) do
    college = FactoryBot.create(:college, name: "Cornell")
    assign(:wrestle_bet_wrestlers, [
      WrestleBet::Wrestler.create!(
        name: "Meyer Shapiro",
        college: college
      ),
      WrestleBet::Wrestler.create!(
        name: "Meyer Shapiro",
        college: college
      )
    ])
  end

  it "renders a list of wrestle_bet/wrestlers" do
    render
    assert_select "div>p", text: "Meyer Shapiro".to_s, count: 2
    assert_select "div>p", text: "Cornell".to_s, count: 2
  end
end

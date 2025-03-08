require 'rails_helper'

RSpec.describe "wrestle_bet/wrestlers/edit", type: :view do
  before(:each) do
    @wrestle_bet_wrestler = assign(:wrestle_bet_wrestler, WrestleBet::Wrestler.create!(
      name: "MyString",
      college: nil
    ))
  end

  it "renders the edit wrestle_bet_wrestler form" do
    render

    assert_select "form[action=?][method=?]", wrestle_bet_wrestler_path(@wrestle_bet_wrestler), "post" do

      assert_select "input[name=?]", "wrestle_bet_wrestler[name]"

      assert_select "input[name=?]", "wrestle_bet_wrestler[college_id]"
    end
  end
end

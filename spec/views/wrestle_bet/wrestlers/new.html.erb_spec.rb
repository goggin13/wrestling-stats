require 'rails_helper'

RSpec.describe "wrestle_bet/wrestlers/new", type: :view do
  before(:each) do
    assign(:colleges, [])
    assign(:wrestle_bet_wrestler, WrestleBet::Wrestler.new(
      name: "MyString",
      college: nil
    ))
  end

  it "renders new wrestle_bet_wrestler form" do
    render

    assert_select "form[action=?][method=?]", wrestle_bet_wrestlers_path, "post" do

      assert_select "input[name=?]", "wrestle_bet_wrestler[name]"

      assert_select "select[name=?]", "wrestle_bet_wrestler[college_id]"
    end
  end
end

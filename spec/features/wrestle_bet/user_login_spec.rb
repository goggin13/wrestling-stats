require "rails_helper"

feature "WrestleBet user authentication from link" do
  before do
    @user = FactoryBot.create(:user, email: "hello@example.com")
    @home_wrestler = FactoryBot.create(:wrestle_bet_wrestler, name: "Gable Steveson")
    @away_wrestler = FactoryBot.create(:wrestle_bet_wrestler, name: "Greg Kerkvliet")
    @match = FactoryBot.create(:wrestle_bet_match,
      weight: 285,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
      spread: 6.5,
    )
    @tournament = @match.tournament
  end

  it "logs a user in with the correct URL" do
    visit wrestle_bet_betslip_path(id: @tournament.id, c: @user.encoded_email)
    expect(page).to have_content("hello@example.com Betslip")
  end

  it "fails to log a user in with the wrong URL" do
    wrong = @user.encoded_email[0..-8]
    expect do
      visit wrestle_bet_betslip_path(id: @tournament.id, c: wrong)
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end

FactoryBot.define do
  factory :wrestle_bet_spread_bet, class: 'WrestleBet::SpreadBet' do
    match factory: :wrestle_bet_match
    user
    wager { "home" }
  end
end

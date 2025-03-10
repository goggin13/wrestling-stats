FactoryBot.define do
  factory :wrestle_bet_prop_bet, class: 'WrestleBet::PropBet' do
    tournament factory: :wrestle_bet_tournament
    user
    jesus { 1 }
    exposure { 1 }
    challenges { 1 }
  end
end

FactoryBot.define do
  factory :wrestle_bet_match, class: 'WrestleBet::Match' do
    weight { 149 }
    started { false }
    spread { 1 }
    home_wrestler factory: :wrestle_bet_wrestler
    away_wrestler factory: :wrestle_bet_wrestler
    tournament factory: :wrestle_bet_tournament
  end
end

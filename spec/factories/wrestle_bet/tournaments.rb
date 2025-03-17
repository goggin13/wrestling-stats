FactoryBot.define do
  factory :wrestle_bet_tournament, class: 'WrestleBet::Tournament' do
    name { "MyString" }
    current_match_id { 1 }
  end
end

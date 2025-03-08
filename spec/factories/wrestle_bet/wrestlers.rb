FactoryBot.define do
  factory :wrestle_bet_wrestler, class: 'WrestleBet::Wrestler' do
    name { "MyString" }
    college { nil }
  end
end

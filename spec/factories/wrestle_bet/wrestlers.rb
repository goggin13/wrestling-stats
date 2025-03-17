FactoryBot.define do
  factory :wrestle_bet_wrestler, class: 'WrestleBet::Wrestler' do
    sequence :name do |n|
      "Kyle Dake - #{n}"
    end

    association :college
  end
end

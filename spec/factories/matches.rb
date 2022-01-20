FactoryBot.define do
  factory :match do
    date { "2022-01-18" }
    association :home_team, factory: :college
    association :away_team, factory: :college
  end
end

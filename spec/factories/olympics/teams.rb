FactoryBot.define do
  factory :olympics_team, class: 'Olympics::Team' do
    sequence(:name) { |n| "Team #{n}" }
    sequence(:number) { |n| n }
  end
end

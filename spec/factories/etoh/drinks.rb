FactoryBot.define do
  factory :etoh_drink, class: 'Etoh::Drink' do
    consumed_at { Time.now }
    oz { 12 }
    abv { 5 }
  end
end

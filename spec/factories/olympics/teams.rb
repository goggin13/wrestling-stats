FactoryBot.define do
  factory :olympics_team, class: 'Olympics::Team' do
    name { "MyString" }
    number { 1 }
  end
end

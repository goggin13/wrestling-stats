FactoryBot.define do
  factory :match do
    date { "2022-01-18" }
    home_team_id { 1 }
    away_team_id { "MyString" }
    integer { "MyString" }
  end
end

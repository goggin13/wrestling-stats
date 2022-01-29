FactoryBot.define do
  factory :wrestler do
    sequence(:name) { |n| "wrestler #{n}" }
    association :college
		rank { 1 }
  end
end

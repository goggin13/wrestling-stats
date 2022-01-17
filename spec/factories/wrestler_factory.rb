FactoryBot.define do
  factory :wrestler do
    sequence(:name) { |n| "wrestler #{n}" }
    college { "Cornell" }
		rank { 1 }
  end
end

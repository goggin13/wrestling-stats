FactoryBot.define do
  factory :college do
    sequence :name do |n|
      "State University - #{n}"
    end
  end
end

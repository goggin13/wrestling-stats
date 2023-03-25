FactoryBot.define do
  factory :advocate_employee, class: 'Advocate::Employee' do
    sequence(:name) { |n| "Doe-#{n}, Jane" }
    sequence(:first) { |n| "Jane" }
    sequence(:last) { |n| "Doe-#{n}" }
    role { "RN" }
  end
end

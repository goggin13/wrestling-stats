FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tester_#{n}@example.com" }
    password { "pass123" }
    password_confirmation { "pass123" }

    trait :admin do
      email { "goggin13@gmail.com" }
    end
  end
end

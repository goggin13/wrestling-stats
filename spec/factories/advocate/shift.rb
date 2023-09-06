FactoryBot.define do
  factory :advocate_shift, class: 'Advocate::Shift' do
    raw_shift_code { "07-12" }
    start { 7 }
    duration { 12 }
    date { "2022-01-18" }
    employee factory: :advocate_employee
  end
end

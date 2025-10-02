FactoryBot.define do
  factory :certification_certification_requirements, class: Certifications::Requirements do
    certification_date { Faker::Date.forward(days: 30) }
    months_that_can_be_certified { [ "2025-09-01" ] }
    number_of_months_to_certify { Faker::Number.within(range: 1..3) }
    due_date { Faker::Date.between(from: 30.days.from_now, to: 60.days.from_now) }

    # TODO: trait for certification type
  end
end

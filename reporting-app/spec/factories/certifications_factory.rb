FactoryBot.define do
  factory :certification do
    beneficiary_id { Faker::NationalHealthService.british_number }
    case_number { "C-%d" % Faker::Number.within(range: 1..10000) }
    certification_requirements { nil }
    beneficiary_data { nil }

    trait :invalid_json_data do
      certification_requirements { "()" }
      beneficiary_data { "()" }
    end

    trait :with_certification_requirements do
      certification_requirements { Faker::Json.shallow_json(width: 3, options: { key: 'Name.first_name', value: 'Name.last_name' }) }
    end

    trait :with_beneficiary_data do
      beneficiary_data { Faker::Json.shallow_json(width: 3, options: { key: 'Name.first_name', value: 'Name.last_name' }) }
    end
  end
end

FactoryBot.define do
  factory :certification do
    id { SecureRandom.uuid }
    beneficiary_id { Faker::NationalHealthService.british_number }
    case_number { "C-%d" % Faker::Number.within(range: 1..10000) }
    beneficiary_data { {} }

    trait :invalid_json_data do
      certification_requirements { "()" }
      beneficiary_data { "()" }
    end

    trait :with_certification_requirements do
      certification_requirements { JSON.parse(Faker::Json.shallow_json(width: 3, options: { key: 'Name.first_name', value: 'Name.last_name' })) }
    end

    trait :with_beneficiary_data_base do
      transient do
        beneficiary_data_base { {} }
      end

      after(:build) do |cert, context|
        cert.beneficiary_data.deep_merge!(context.beneficiary_data_base)
      end
    end

    trait :connected_to_email do
      transient do
        email { nil }
      end

      after(:build) do |cert, context|
        if not context.email.blank?
          cert.beneficiary_data.deep_merge!({
            "account_email": context.email,
            "contact": {
              "email": context.email,
              "phone": Faker::PhoneNumber.cell_phone_in_e164
            }
        })
        end
      end
    end

    trait :with_activity_report_application_form do
      activity_report_application_forms { [ association(:activity_report_application_form) ] }
    end
  end
end

FactoryBot.define do
  factory :certification do
    id { SecureRandom.uuid }
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

    # TODO: be able to pass user to set bene data to match
    # trait :connected_to_user do
    #   beneficiary_data { {
    #         "contact": {
    #           "email": "john@doe.com",
    #           "phone": "+123456789"
    #         }
    #     } }
    # end

    trait :with_beneficiary_data_partially_exempt do
      beneficiary_data {
        {
          "payroll_accounts":
            [
              {
                "company_name": "Acme",
                "paychecks":
                  [
                    {
                      "period_start": "2025-01-01",
                      "period_end": "2025-01-15",
                      "gross": "123.45",
                      "net": "50.00"
                    }
                  ]
              }
            ]
        }
      }
    end

    trait :with_beneficiary_data_exempt do
      beneficiary_data {
        {
          "payroll_accounts":
            [
              {
                "company_name": "Acme",
                "paychecks":
                  [
                    {
                      "period_start": "2025-01-01",
                      "period_end": "2025-01-15",
                      "gross": "123.45",
                      "net": "50.00"
                    }
                  ]
              }
            ]
        }
      }
    end

    trait :with_activity_report_application_form do
      activity_report_application_forms { [ association(:activity_report_application_form) ] }
    end
  end
end

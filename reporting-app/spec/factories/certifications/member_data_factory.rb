# frozen_string_literal: true

FactoryBot.define do
  factory :certification_member_data, class: Certifications::MemberData do
    skip_create

    transient do
      cert_date { Date.today }
      num_months { 1 }
    end

    trait :with_name do
      name do
        {
          "first": Faker::Name.first_name,
          "middle": Faker::Name.middle_name,
          "last": Faker::Name.last_name,
          "suffix": ""
        }
      end
    end

    trait :with_account_email do
      account_email { Faker::Internet.email }
    end

    trait :partially_met_work_hours_requirement do
      payroll_accounts {
        [
          {
            "company_name": "Acme",
            "paychecks":
              [
                {
                  "period_start": cert_date.beginning_of_month,
                  "period_end": cert_date.end_of_month,
                  "gross": "123.45",
                  "net": "50.00",
                  "hours_worked": "10"
                }
              ]
          }
        ]
      }
    end

    trait :fully_met_work_hours_requirement do
      payroll_accounts {
        [
          {
            "company_name": "Acme",
            "paychecks": num_months.times.map { |i|
              {
                "period_start": cert_date.beginning_of_month << i,
                "period_end": cert_date.end_of_month << i,
                "gross": "2000.00",
                "net": "1000.00",
                "hours_worked": "80"
              }
            }
          }
        ]
      }
    end
  end
end

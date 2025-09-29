FactoryBot.define do
  factory :certification_beneficiary_data, class: Hash do
    skip_create
    initialize_with { attributes }

    transient do
      cert_date { Date.today }
      num_months { 1 }
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

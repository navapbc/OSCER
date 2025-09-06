FactoryBot.define do
  factory :activity do
    activity_report_application_form { create(:activity_report_application_form) }
    month { Date.today.prev_month.beginning_of_month }
    hours { Faker::Number.between(from: 1.0, to: 100.0) }
    name { Faker::Company.name }
  end
end

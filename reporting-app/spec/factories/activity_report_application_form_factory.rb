FactoryBot.define do
  factory :activity_report_application_form do
    employer_name { Faker::Company.name }
    minutes { 15*rand(1..500) }
    reporting_period { Date.new(rand(2000..Date.today.year), rand(1..12), 1) }

    trait :with_activities do
      after(:create) do |activity_report_application_form|
        activities = create_list(:activity, 3, activity_report_application_form_id: activity_report_application_form.id)
        activity_report_application_form.activities = activities
      end
    end
  end
end

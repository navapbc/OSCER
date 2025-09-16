FactoryBot.define do
  factory :activity_report_application_form do
    activities { [] }

    trait :with_activities do
      after(:create) do |activity_report_application_form|
        activity_report_application_form.activities = create_list(
          :activity, 3, activity_report_application_form_id: activity_report_application_form.id
        )
      end
    end
  end
end

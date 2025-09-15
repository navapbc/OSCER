FactoryBot.define do
  factory :activity_report_case do
    trait :with_activities_and_documents do
      after(:create) do |case_instance|
        application_form = create(:activity_report_application_form)
        case_instance.update!(application_form_id: application_form.id)
        create_list(:activity, 2, activity_report_application_form_id: application_form.id)
      end
    end
  end
end

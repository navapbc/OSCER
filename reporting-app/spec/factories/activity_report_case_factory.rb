FactoryBot.define do
  factory :activity_report_case do
    business_process_current_step { "submit_report" }
    application_form_id { nil }

    initialize_with {
      application_form = create(:activity_report_application_form)
      ActivityReportCase.find_or_create_by!(application_form_id: application_form.id)
    }

    trait :with_activities do
      initialize_with {
        application_form = create(:activity_report_application_form, :with_activities)
        ActivityReportCase.find_or_create_by!(application_form_id: application_form.id)
      }
    end

    trait :with_submitted_form do
      after(:create) do |activity_report_case|
        activity_report_case.application_form.submit_application
      end
    end
  end
end

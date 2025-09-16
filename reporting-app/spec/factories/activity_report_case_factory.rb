FactoryBot.define do
  factory :activity_report_case do
    initialize_with {
      application_form = create(:activity_report_application_form, :with_activities)
      application_form.submit_application
      application_form.reload

      ActivityReportCase.find_or_create_by!(application_form_id: application_form.id)
    }
  end
end

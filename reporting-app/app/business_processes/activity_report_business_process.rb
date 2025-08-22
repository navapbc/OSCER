class ActivityReportBusinessProcess < Flex::BusinessProcess
  applicant_task("submit_report")
  staff_task("review_report", ReviewActivityReportTask)

  start_on_application_form_created("submit_report")

  transition("submit_report", "ActivityReportApplicationFormSubmitted", "review_report")
  transition("review_report", "ActivityReportReviewed", "end")
end

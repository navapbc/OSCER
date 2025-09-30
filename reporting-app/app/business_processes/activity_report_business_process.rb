class ActivityReportBusinessProcess < Strata::BusinessProcess
  applicant_task("submit_report")
  staff_task("review_report", ReviewActivityReportTask)
  system_process("activity_report_task_approved", ->(kase) {
    kase.handle_review_task_completed("approved")
  })
  system_process("activity_report_task_denied", ->(kase) {
    kase.handle_review_task_completed("denied")
  })
  system_process("activity_report_notification", ->(kase) {
    # Send notification to user
    Strata::EventManager.publish("ActivityReportNotificationSent", { case_id: kase.id })
  })

  start_on_application_form_created("submit_report")

  transition("submit_report", "ActivityReportApplicationFormSubmitted", "review_report")
  transition("review_report", "ReviewActivityReportTaskApproved", "activity_report_task_approved")
  transition("review_report", "ReviewActivityReportTaskDenied", "activity_report_task_denied")
  transition("activity_report_task_approved", "ActivityReportStatusUpdated", "activity_report_notification")
  transition("activity_report_task_denied", "ActivityReportStatusUpdated", "activity_report_notification")
  transition("activity_report_notification", "ActivityReportNotificationSent", "end")
end

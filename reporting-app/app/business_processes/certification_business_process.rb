class CertificationBusinessProcess < Strata::BusinessProcess
  # def self.case_class
  #   "CertificationCase"
  # end


  # applicant_task('submit_application')

  # start_on_application_form_created('submit_application')

  # transition('submit_application', 'CertificationApplicationFormSubmitted', 'example_1')
  # transition('example_1', 'a_different_event', 'end')

  # start on certification created

  # system process to do exemption check

  # transition to determined exemption OR
  # transition to ex_parte_determination

  # transition to ex_parte_determination_complete and requirements met OR
  # transition to ex_parte_determination_complete and requirements not met -> submit activities

  # activity report submitted
  # applicant_task("activity_report_submitted")
  # staff_task("review_activity_report", ReviewActivityReportTask)
  # system_process("activity_report_task_approved", ->(kase) {
  #   kase.handle_review_activity_report_task_completed("approved")
  # })
  # system_process("activity_report_task_denied", ->(kase) {
  #   kase.handle_review_activity_report_task_completed("denied")
  # })
  # system_process("activity_report_notification", ->(kase) {
  #   # Send notification to user
  #   Strata::EventManager.publish("ActivityReportNotificationSent", { case_id: kase.id })
  # })

  # transition("activity_report_submitted", "ActivityReportApplicationFormSubmitted", "review_activity_report")
  # transition("review_report", "ReviewActivityReportTaskApproved", "activity_report_task_approved")
  # transition("review_report", "ReviewActivityReportTaskDenied", "activity_report_task_denied")
  # transition("activity_report_task_approved", "ActivityReportStatusUpdated", "activity_report_notification")
  # transition("activity_report_task_denied", "ActivityReportStatusUpdated", "activity_report_notification")
  # transition("activity_report_notification", "ActivityReportNotificationSent", "end") # This is not really the end
  # exemption application form submitted -> staff task to review exemption application form

  # staff review and request for more information and determine exempted or requirements met
  # applicant_task("submit_application")
  # staff_task("review_exemption_claim", ReviewExemptionClaimTask)

  # start_on_application_form_created("submit_application")

  # transition("submit_application", "ExemptionApplicationFormSubmitted", "review_exemption_claim")
  # transition("review_exemption_claim", "ExemptionClaimReviewed", "end")
end

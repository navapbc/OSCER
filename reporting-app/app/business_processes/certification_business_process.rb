class CertificationBusinessProcess < Strata::BusinessProcess
  # define steps on certification created
  #
  #  # TODO: system process to do exemption check
  # system_process("ExemptionCheck", ->(kase) {
  # })
  #
  # activity report submitted
  staff_task("review_activity_report", ReviewActivityReportTask)
  system_process("activity_report_task_approved", ->(kase) {
    kase.handle_review_activity_report_task_completed("approved")
  })
  system_process("activity_report_task_denied", ->(kase) {
    kase.handle_review_activity_report_task_completed("denied")
  })
  system_process("activity_report_notification", ->(kase) {
    # Send notification to user
    Strata::EventManager.publish("ActivityReportNotificationSent", { case_id: kase.id })
  })


  # define start step
  start("certification_created", on: "CertificationCreated") do |event|
    Rails.logger.info("Hello World!!! CertificationCreated")
    CertificationCase.new(certification_id: event[:payload][:certification_id])
  end

  # define transitions
  # looks like when we submit the activity report, the case current step did not change
  transition("activity_report_submitted", "ActivityReportApplicationFormSubmitted", "review_activity_report")
  transition("certification_created", "ActivityReportApplicationFormSubmitted", "review_activity_report")
  transition("review_activity_report", "ReviewActivityReportTaskApproved", "activity_report_task_approved")
  transition("review_activity_report", "ReviewActivityReportTaskDenied", "activity_report_task_denied")
  transition("activity_report_task_approved", "ActivityReportStatusUpdated", "activity_report_notification")
  transition("activity_report_task_denied", "ActivityReportStatusUpdated", "activity_report_notification")
  transition("activity_report_notification", "ActivityReportNotificationSent", "end") # This is not really the end

  # TODO: Ex Parte Determination Process

  # transition to ex_parte_determination_complete and requirements met OR
  # transition to ex_parte_determination_complete and requirements not met -> submit activities or submit exemption request

  # exemption application form submitted -> staff task to review exemption application form

  # staff review and request for more information and determine exempted or requirements met
  # applicant_task("submit_application")
  # staff_task("review_exemption_claim", ReviewExemptionClaimTask)

  # start_on_application_form_created("submit_application")

  # transition("submit_application", "ExemptionApplicationFormSubmitted", "review_exemption_claim")
  # transition("review_exemption_claim", "ExemptionClaimReviewed", "end")
end

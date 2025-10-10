# frozen_string_literal: true

class CertificationBusinessProcess < Strata::BusinessProcess
  # TODO: system process to do exemption check
  # system_process("ExemptionCheck", ->(kase) {
  # })
  # TODO: system process for Ex Parte Determination
  # system_process("ExParteDetermination", ->(kase) {
  # })

  staff_task("review_activity_report", ReviewActivityReportTask)
  system_process("activity_report_task_approved", ->(kase) {
    kase.accept_activity_report
  })
  system_process("activity_report_task_denied", ->(kase) {
    kase.deny_activity_report
  })

  # define start step
  start("report_activities", on: "CertificationCreated") do |event|
    CertificationCase.new(certification_id: event[:payload][:certification_id])
  end

  # define transitions
  transition("activity_report_submitted", "ActivityReportApplicationFormSubmitted", "review_activity_report")
  transition("report_activities", "ActivityReportApplicationFormSubmitted", "review_activity_report")
  transition("review_activity_report", "ReviewActivityReportTaskApproved", "activity_report_task_approved")
  transition("review_activity_report", "ReviewActivityReportTaskDenied", "activity_report_task_denied")
  transition("activity_report_task_approved", "ActivityReportStatusUpdated", "activity_report_notification")
  transition("activity_report_task_denied", "ActivityReportStatusUpdated", "activity_report_notification")
end

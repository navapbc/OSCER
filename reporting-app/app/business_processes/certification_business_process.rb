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
  staff_task("review_exemption_claim", ReviewExemptionClaimTask)
  system_process("exemption_claim_task_approved", ->(kase) {
    kase.accept_exemption_request
  })
  system_process("exemption_claim_task_denied", ->(kase) {
    kase.deny_exemption_request
  })

  # define start step
  start("report_activities", on: "CertificationCreated") do |event|
    CertificationCase.new(certification_id: event[:payload][:certification_id])
  end

  # define transitions
  transition("report_activities", "ActivityReportApplicationFormSubmitted", "review_activity_report")
  transition("review_activity_report", "ReviewActivityReportTaskApproved", "activity_report_task_approved")
  transition("review_activity_report", "ReviewActivityReportTaskDenied", "activity_report_task_denied")

  transition("report_activities", "ExemptionApplicationFormSubmitted", "review_exemption_claim")
  transition("review_exemption_claim", "ReviewExemptionClaimTaskApproved", "exemption_claim_task_approved")
  transition("review_exemption_claim", "ReviewExemptionClaimTaskDenied", "exemption_claim_task_denied")

  # TODO: There is no end step, RFI will take place after the we get a denied.
end

# frozen_string_literal: true

class CertificationBusinessProcess < Strata::BusinessProcess
  # TODO: system process to do exemption check
  # system_process("ExemptionCheck", ->(kase) {
  # })
  # TODO: system process for Ex Parte Determination
  # system_process("ExParteDetermination", ->(kase) {
  # })

  staff_task("review_activity_report", ReviewActivityReportTask)
  system_process("approve_activity_report_task", ->(kase) {
    kase.accept_activity_report
  })
  system_process("deny_activity_report_task", ->(kase) {
    kase.deny_activity_report
  })
  staff_task("review_exemption_claim", ReviewExemptionClaimTask)
  system_process("approve_exemption_claim_task", ->(kase) {
    kase.accept_exemption_request
  })
  system_process("deny_exemption_claim_task", ->(kase) {
    kase.deny_exemption_request
  })

  # define start step
  start("report_activities", on: "CertificationCreated") do |event|
    CertificationCase.new(certification_id: event[:payload][:certification_id])
  end

  # define transitions
  transition("report_activities", "ActivityReportApplicationFormSubmitted", "review_activity_report")
  transition("review_activity_report", "ReviewActivityReportTaskApproved", "approve_activity_report_task")
  transition("review_activity_report", "ReviewActivityReportTaskDenied", "deny_activity_report_task")

  transition("report_activities", "ExemptionApplicationFormSubmitted", "review_exemption_claim")
  transition("review_exemption_claim", "ReviewExemptionClaimTaskApproved", "approve_exemption_claim_task")
  transition("review_exemption_claim", "ReviewExemptionClaimTaskDenied", "deny_exemption_claim_task")

  # End step only on acceptance of activity report or exemption request
  transition("approve_activity_report_task", "DeterminedRequirementsMet", "end")
  transition("approve_exemption_claim_task", "DeterminedRequirementsMet", "end")
end

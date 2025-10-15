# frozen_string_literal: true

class CertificationBusinessProcess < Strata::BusinessProcess
  # TODO: system process to do exemption check
  # system_process("ExemptionCheck", ->(kase) {
  # })
  # TODO: system process for Ex Parte Determination
  # system_process("ExParteDetermination", ->(kase) {
  # })

  applicant_task("report_activities")
  staff_task("review_activity_report", ReviewActivityReportTask)
  staff_task("review_exemption_claim", ReviewExemptionClaimTask)

  # define start step
  start("report_activities", on: "CertificationCreated") do |event|
    CertificationCase.new(certification_id: event[:payload][:certification_id])
  end

  # define transitions
  transition("report_activities", "ActivityReportApplicationFormSubmitted", "review_activity_report")
  transition("review_activity_report", "DeterminedRequirementsMet", "end")
  transition("review_activity_report", "DeterminedRequirementsNotMet", "end")

  transition("report_activities", "ExemptionApplicationFormSubmitted", "review_exemption_claim")
  transition("review_exemption_claim", "DeterminedExempt", "end")
  transition("review_exemption_claim", "DeterminedNotExempt", "report_activities")
end

class ExemptionBusinessProcess < Flex::BusinessProcess
  applicant_task("submit_application")
  staff_task("review_exemption_claim", ReviewExemptionClaimTask)

  start_on_application_form_created("submit_application")

  transition("submit_application", "ExemptionApplicationFormSubmitted", "review_exemption_claim")
  transition("review_exemption_claim", "ExemptionClaimReviewed", "end")
end

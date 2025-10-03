# frozen_string_literal: true

FactoryBot.define do
  # This is possible because Strata::Task is not abstract
  factory :task, class: Strata::Task do
    description { "Review the TO DO" }
    due_on { Date.today + 1.week }
    case_type { "CertificationCase" }
  end

  factory :review_exemption_claim_task, parent: :task do
    type { "ReviewExemptionClaimTask" }
  end

  factory :review_activity_report_task, parent: :task do
    type { "ReviewActivityReportTask" }
  end
end

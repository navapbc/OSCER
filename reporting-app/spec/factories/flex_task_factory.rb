FactoryBot.define do
  # This is possible because Flex::Task is not abstract
  factory :task, class: Flex::Task do
    description { "Review the TO DO" }
    due_on { Date.today + 1.week }
  end

  factory :review_activity_report_task, parent: :task do
    case_type { "ActivityReportCase" }
    type { "ReviewActivityReportTask" }
  end

  factory :review_exemption_claim_task, parent: :task do
    case_type { "ExemptionCase" }
    type { "ReviewExemptionClaimTask" }
  end
end

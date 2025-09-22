FactoryBot.define do
  factory :review_activity_report_task, class: ReviewActivityReportTask do
    case_type { "ActivityReportCase" }
    type { "ReviewActivityReportTask" }
  end
end

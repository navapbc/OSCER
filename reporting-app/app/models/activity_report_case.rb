class ActivityReportCase < Flex::Case
  has_one :application_form, foreign_key: :id, primary_key: :application_form_id, class_name: "ActivityReportApplicationForm"

  default_scope { includes(:application_form) }
end

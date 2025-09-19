class ActivityReportCase < Flex::Case
  has_one :application_form, foreign_key: :id, primary_key: :application_form_id, class_name: "ActivityReportApplicationForm"

  default_scope { includes(:application_form) }
  store_accessor :facts, :activity_report_approval_status
  def handle_review_task_completed(status) 
    raise "Invalid status" unless ["approved", "denied"].include?(status)

    self.activity_report_approval_status = status
    save!

    Flex::EventManager.publish("ActivityReportStatusUpdated", { case_id: id })
  end
end

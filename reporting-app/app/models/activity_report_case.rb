class ActivityReportCase < Strata::Case
  store_accessor :facts, :activity_report_approval_status, :activity_report_approval_status_updated_at

  def handle_review_task_completed(status)
    raise "Invalid status" unless [ "approved", "denied" ].include?(status)

    self.activity_report_approval_status = status
    self.activity_report_approval_status_updated_at = Time.current
    save!

    Strata::EventManager.publish("ActivityReportStatusUpdated", { case_id: id })
  end
end

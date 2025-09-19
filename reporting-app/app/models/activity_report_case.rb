class ActivityReportCase < Flex::Case
  store_accessor :facts, :activity_report_approval_status

  def handle_review_task_completed(status)
    raise "Invalid status" unless [ "approved", "denied" ].include?(status)

    self.activity_report_approval_status = status
    save!

    Flex::EventManager.publish("ActivityReportStatusUpdated", { case_id: id })
  end
end

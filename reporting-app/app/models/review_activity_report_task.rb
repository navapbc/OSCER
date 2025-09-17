class ReviewActivityReportTask < Flex::Task
  # Extend the status enum with new values
  enum :status, { pending: 0, completed: 1, approved: 2, denied: 3 }, prefix: :mark
  public attr_writer :status

  after_save :publish_completed_event, if: :saved_change_to_status?, on: :update

  private
  def publish_completed_event
    case status
    when "approved", "denied"
      Flex::EventManager.publish("#{self.class.name}#{status}", { task_id: id, case_id: case_id })
    when "pending", "completed"
      send("mark_#{status}") # the parent class handles these
    end
  end
end

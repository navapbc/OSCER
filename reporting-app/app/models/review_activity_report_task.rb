class ReviewActivityReportTask < Flex::Task
  # Extend the status enum with new values
  enum :status, { pending: 0, completed: 1, approved: 2, denied: 3 }

  def approve
    self[:status] = :approved
    save!
  end

  def deny
    self[:status] = :denied
    save!
  end

  def completed?
    %w[completed approved denied].include?(status)
  end
end

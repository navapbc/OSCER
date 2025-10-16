# frozen_string_literal: true

class ReviewActivityReportTask < Strata::Task
  # Extend the status enum with new values
  enum :status, { pending: 0, completed: 1, approved: 2, denied: 3 }
end

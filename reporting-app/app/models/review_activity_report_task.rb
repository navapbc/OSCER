# frozen_string_literal: true

class ReviewActivityReportTask < Strata::Task
  # TODO: move :on_hold to Strata::Task
  enum :status, { pending: 0, completed: 1, on_hold: 2 }
end

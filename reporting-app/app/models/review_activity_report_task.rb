# frozen_string_literal: true

class ReviewActivityReportTask < Strata::Task
  attribute :due_on, :date, default: -> { 7.days.from_now.to_date }
end

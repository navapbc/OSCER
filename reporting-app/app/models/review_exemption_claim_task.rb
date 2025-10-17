# frozen_string_literal: true

class ReviewExemptionClaimTask < Strata::Task
  # TODO: Figure out a better way to handle default due dates for tasks
  attribute :due_on, :date, default: -> { 7.days.from_now.to_date }
end

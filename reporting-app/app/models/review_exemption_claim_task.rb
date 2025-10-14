# frozen_string_literal: true

class ReviewExemptionClaimTask < Strata::Task
  enum status: { pending: 0, completed: 1, approved: 2, denied: 3 }
  attribute :due_on, :date, default: -> { 7.days.from_now.to_date }
end

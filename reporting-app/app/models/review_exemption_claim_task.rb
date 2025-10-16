# frozen_string_literal: true

class ReviewExemptionClaimTask < Strata::Task
  enum status: { pending: 0, completed: 1, approved: 2, denied: 3 }
end

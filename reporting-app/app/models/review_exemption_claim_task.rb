# frozen_string_literal: true

class ReviewExemptionClaimTask < Strata::Task
  # TODO: move :on_hold to Strata::Task
  enum :status, { pending: 0, completed: 1, on_hold: 2 }

  def self.application_form_class
    ExemptionApplicationForm
  end
end

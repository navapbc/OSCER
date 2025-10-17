# frozen_string_literal: true

class ReviewExemptionClaimTask < Strata::Task
  def self.application_form_class
    ExemptionApplicationForm
  end
end

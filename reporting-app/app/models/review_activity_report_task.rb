# frozen_string_literal: true

class ReviewActivityReportTask < Strata::Task
  def self.application_form_class
    ActivityReportApplicationForm
  end
end

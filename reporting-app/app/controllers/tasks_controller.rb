# frozen_string_literal: true

class TasksController < Strata::TasksController
  private

  def set_application_form
    @application_form = ActivityReportApplicationForm.find_by(certification_case_id: @case.id) ||
                        ExemptionApplicationForm.find_by(id: @case.application_form_id)
  end
end

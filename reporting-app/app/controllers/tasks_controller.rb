# frozen_string_literal: true

class TasksController < Strata::TasksController
  private

  def set_application_form
    # CertificationCase can be tied to different application forms
    @application_form = ActivityReportApplicationForm.find_by(certification_case_id: @case.id) ||
                        ExemptionApplicationForm.find_by(certification_case_id: @case.id)
  end
end

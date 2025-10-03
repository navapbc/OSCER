# frozen_string_literal: true

class TasksController < Strata::TasksController
  before_action :set_certification, only: %i[ show update ]

  private

  def set_certification
    @certification = Certification.find(@case.certification_id)
  end

  def set_application_form
    # CertificationCase can be tied to different application forms
    @application_form = ActivityReportApplicationForm.find_by(certification_id: @case.certification_id) ||
                        ExemptionApplicationForm.find_by(certification_id: @case.certification_id)
  end
end

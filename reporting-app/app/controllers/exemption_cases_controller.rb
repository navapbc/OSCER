# frozen_string_literal: true

class ExemptionCasesController < StaffController
  before_action :set_exemption_case, only: %i[ show tasks documents notes update destroy ]
  before_action :set_exemption_application_form, only: %i[ documents ]

  def index
    @cases = ExemptionCase.open
  end

  def closed
    @cases = ExemptionCase.closed
    render :index
  end

  def show
  end

  def tasks
    @tasks = @case.tasks
  end

  def documents
    @documents = @exemption_application_form.supporting_documents
  end

  def notes
  end

  private

  def set_exemption_case
    @case = ExemptionCase.find(params[:id])
  end

  def set_exemption_application_form
    @exemption_application_form = ExemptionApplicationForm.find(@case.application_form_id)
  end
end

class ExemptionCasesController < StaffController
  before_action :set_exemption_case, only: %i[ show tasks documents update destroy ]
  before_action :set_exemption_application_form, only: %i[ documents ]

  def index
    @cases = ExemptionCase.all
  end

  def closed
    @cases = ExemptionCase.where(status: "closed").order(created_at: :desc)
    render :index
  end

  def show
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  def tasks
    @tasks = @case.tasks
  end

  def documents
    @documents = @exemption_application_form.supporting_documents
  end

  private

  def set_exemption_case
    @case = @exemption_case = ExemptionCase.find(params[:id])
  end

  def set_exemption_application_form
    @exemption_application_form = ExemptionApplicationForm.find(@exemption_case.application_form_id)
  end
end

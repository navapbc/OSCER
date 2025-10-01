class CertificationCasesController < StaffController
  before_action :set_certification_case, only: %i[ show tasks documents notes ]

  def index
    @certification_cases = CertificationCase.all
  end

  def closed
    @certification_cases = CertificationCase.closed
    render :index
  end

  def show
  end

  def tasks
    @tasks = @certification_case.tasks
  end

  def documents
  end

  def notes
  end

  private

  def set_certification_case
    @certification_case = CertificationCase.find(params[:id])
  end
end

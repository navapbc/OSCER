class CertificationCasesController < StaffController
  before_action :set_certification_case, only: %i[ show tasks documents notes ]
  before_action :set_certification, only: %i[ show ]

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
    @tasks = @case.tasks
  end

  def documents
  end

  def notes
  end

  private

  def set_certification_case
    @case = CertificationCase.find(params[:id])
  end

  def set_certification
    @certification = Certification.find(@case.certification_id)
  end
end

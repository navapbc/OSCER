class CertificationCasesController < StaffController
  before_action :set_certification_elements, only: %i[ show tasks documents notes ]

  def index
    @cases = CertificationCase.all
  end

  def closed
    @cases = CertificationCase.closed
    render :index
  end

  def show
  end

  def tasks
    @tasks = @case.tasks
  end

  def documents
    @documents = []
  end

  def notes
  end

  private

  def set_certification_elements
    @case = CertificationCase.find(params[:id])
    @certification = Certification.find(@case.certification_id)
  end
end

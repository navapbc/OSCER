# frozen_string_literal: true

class CertificationCasesController < StaffController
  before_action :set_certification_elements, only: %i[ show tasks documents notes ]

  def index
    cases = CertificationCase.all
    certification_ids = cases.map(&:certification_id)
    certifications_by_id = Certification.where(id: certification_ids).index_by(&:id)
    @cases = cases.map do |kase|
      certification = certifications_by_id[kase.certification_id]
      CertificationCases::CaseRowComponent::Case.new(
        certification_case: kase,
        certification: certification,
        path: certification_case_path(kase)
      )
    end
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

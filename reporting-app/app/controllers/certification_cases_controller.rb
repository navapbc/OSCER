# frozen_string_literal: true

class CertificationCasesController < StaffController
  before_action :set_case, only: %i[ show tasks documents notes ]
  before_action :set_certification, only: %i[ show tasks documents notes ]

  def index
    @cases = CertificationCase.open
    hydrate_cases_with_certifications(@cases)
  end

  def closed
    @cases = CertificationCase.closed
    hydrate_cases_with_certifications(@cases)
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

  def set_case
    @case = CertificationCase.find(params[:id])
  end

  def set_certification
    @certification = Certification.find(@case.certification_id)
  end

  def hydrate_cases_with_certifications(cases)
    certification_ids = cases.map(&:certification_id)
    certifications_by_id = Certification.where(id: certification_ids).index_by(&:id)
    cases.each do |kase|
      kase.certification = certifications_by_id[kase.certification_id]
    end
  end
end

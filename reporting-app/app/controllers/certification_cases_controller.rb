# frozen_string_literal: true

class CertificationCasesController < StaffController
  before_action :set_case, only: %i[ show tasks documents notes ]
  before_action :set_certification, only: %i[ show tasks documents notes ]

  def index
    @cases = certification_service.fetch_open_cases
  end

  def closed
    @cases = certification_service.fetch_closed_cases
    render :index
  end

  def show
  end

  private

  def set_case
    @case = CertificationCase.find(params[:id])
  end

  def set_certification
    @certification = Certification.find(@case.certification_id)
    @case.certification = @certification
    @member = Member.from_certification(@certification)
  end

  def certification_service
    CertificationService.new
  end
end

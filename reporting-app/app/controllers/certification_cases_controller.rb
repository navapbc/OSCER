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
    @information_requests = InformationRequest.for_application_forms(application_form_ids)
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

  def application_form_ids
    [ ActivityReportApplicationForm, ExemptionApplicationForm ].flat_map do |form_class|
      form_class.for_certification_case(@case).pluck(:id)
    end
  end
end

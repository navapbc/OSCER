class DashboardController < ApplicationController
  before_action :authenticate_user!

  # TODO: figure out authz
  skip_after_action :verify_policy_scoped

  # GET /dashboard or /dashboard.json
  def index
    @all_certifications = CertificationRequest.find_by_beneficiary_email(current_user.email).order(created_at: :desc).all
    @certification_request = @all_certifications.first
    if @certification_request
      @exemption_application_form = ExemptionApplicationForm.find_by(certification_request_id: @certification_request&.id)
      @exemption_case = ExemptionCase.find_by(application_form_id: @exemption_application_form&.id)
      @activity_report_application_form = policy_scope(ActivityReportApplicationForm).find_by(certification_request_id: @certification_request&.id)
      @activity_report_case = ActivityReportCase.find_by(application_form_id: @activity_report_application_form&.id)
    end
  end
end

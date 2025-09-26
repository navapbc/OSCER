class DashboardController < ApplicationController
  before_action :authenticate_user!

  # GET /dashboard or /dashboard.json
  def index
    # Create a certification on /staff/certifications to reset the exemption application form lfecycle
    # not scoped to the current user
    @certification = Certification.order(created_at: :desc).first
    @exemption_application_form = ExemptionApplicationForm.find_by(certification_id: @certification&.id)
    @exemption_case = ExemptionCase.find_by(application_form_id: @exemption_application_form&.id)
    @activity_report_application_form = policy_scope(ActivityReportApplicationForm).find_by(certification_id: @certification&.id)
    @activity_report_case = ActivityReportCase.find_by(application_form_id: @activity_report_application_form&.id)
  end
end

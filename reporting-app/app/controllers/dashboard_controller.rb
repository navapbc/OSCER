class DashboardController < ApplicationController
  before_action :authenticate_user!

  # GET /dashboard or /dashboard.json
  def index
    @activity_report_application_forms = policy_scope(ActivityReportApplicationForm).order(created_at: :desc)
    @in_progress_activity_reports = @activity_report_application_forms.in_progress

    # Create a certification on /staff/certifications to reset the exemption application form lfecycle
    # not scoped to the current user
    @certification = Certification.last
    @exemption_application_form = ExemptionApplicationForm.find_by(certification_id: @certification.id)
  end
end

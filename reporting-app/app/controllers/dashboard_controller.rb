class DashboardController < ApplicationController
  before_action :authenticate_user!

  # GET /dashboard or /dashboard.json
  def index
    @activity_report_application_forms = policy_scope(ActivityReportApplicationForm).order(created_at: :desc)
    @activity_report_cases = ActivityReportCase.where(application_form_id: @activity_report_application_forms.pluck(:id)).index_by(&:application_form_id)
    @exemption_application_forms = policy_scope(ExemptionApplicationForm).order(created_at: :desc)
    @in_progress_activity_reports = @activity_report_application_forms.in_progress
    @has_current_exemption = false # TODO: Exemptions will need to be retrieved from another source in the future
  end
end

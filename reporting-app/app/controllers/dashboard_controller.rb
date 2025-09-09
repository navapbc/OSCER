class DashboardController < ApplicationController
    before_action :authenticate_user!

    # GET /dashboard or /dashboard.json
    def index
        @activity_report_application_forms = policy_scope(ActivityReportApplicationForm).order(created_at: :desc)
        @in_progress_activity_reports = @activity_report_application_forms.in_progress
    end
end

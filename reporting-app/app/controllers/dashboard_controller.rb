# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  # TODO: figure out authz
  skip_after_action :verify_policy_scoped

  # GET /dashboard or /dashboard.json
  def index
    @all_certifications = Certification.find_by_member_email(current_user.email).order(created_at: :desc).all
    @certification = @all_certifications.first
    if @certification
      # TODO: This logic here needs to be refactored
      @exemption_application_form = ExemptionApplicationForm.find_by(certification_id: @certification&.id)
      @activity_report_application_form = policy_scope(ActivityReportApplicationForm).where(certification_id: @certification&.id).order(created_at: :asc).last
      @certification_case = CertificationCase.find_by(certification_id: @certification&.id)
    end
  end
end

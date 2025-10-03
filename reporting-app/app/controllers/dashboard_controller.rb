# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  # TODO: figure out authz
  skip_after_action :verify_policy_scoped

  # GET /dashboard or /dashboard.json
  def index
    @all_certifications = Certification.find_by_beneficiary_email(current_user.email).order(created_at: :desc).all
    @certification = @all_certifications.first
    if @certification
      @exemption_application_form = ExemptionApplicationForm.find_by(certification_id: @certification&.id)
      @activity_report_application_form = policy_scope(ActivityReportApplicationForm).find_by(certification_id: @certification&.id)
      @certification_case = CertificationCase.find_by(certification_id: @certification&.id)
    end
  end
end

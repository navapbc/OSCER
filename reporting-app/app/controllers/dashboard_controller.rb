# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  # TODO: figure out authz
  skip_after_action :verify_policy_scoped

  # GET /dashboard or /dashboard.json
  def index
    @all_certifications = Certification.find_by_member_email(current_user.email).order(created_at: :desc).all
    @certification = @all_certifications.first
    @certification_case = CertificationCase.find_by(certification_id: @certification&.id)
    if @certification_case
      @exemption_application_form = ExemptionApplicationForm.where(certification_case_id: @certification_case&.id).order(created_at: :desc).first
      @activity_report_application_form = policy_scope(ActivityReportApplicationForm).where(certification_case_id: @certification_case&.id).order(created_at: :desc).first
    end
  end
end

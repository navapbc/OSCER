# frozen_string_literal: true

class ActivityReportApplicationFormsController < ApplicationController
  before_action :set_activity_report_application_form, only: %i[
    show
    edit
    review
    update
    submit
    destroy
  ]
  before_action :set_activity_report_case, only: %i[ show ]
  before_action :authenticate_user!
  before_action :set_certification_case, only: %i[ new ]
  before_action :create_activity_report, only: %i[ new ]
  before_action :redirect_to_ivaas, only: %i[ new show edit ], if: :reporting_source_ivaas?

  # GET /activity_report_application_forms/1 or /activity_report_application_forms/1.json
  def show
  end

  # GET /activity_report_application_forms/new
  def new
  end

  # GET /activity_report_application_forms/1/edit
  #
  # @param reporting_source [String] Override which reporting service to use ("income_verification_service", "reporting_app")
  def edit
    respond_to do |format|
      format.html
      format.json { render json: @activity_report_application_form.as_json }
    end
  end

  # GET /activity_report_application_forms/1/review
  def review
  end

  # PATCH/PUT /activity_report_application_forms/1 or /activity_report_application_forms/1.json
  def update
    respond_to do |format|
      if @activity_report_application_form.update(activity_report_application_form_params)
        format.html { redirect_to @activity_report_application_form, notice: "Activity report application form was successfully updated." }
        format.json { render :show, status: :ok, location: review_activity_report_application_form_path(@activity_report_application_form) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity_report_application_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /activity_report_application_forms/1/submit
  def submit
    if @activity_report_application_form.submit_application
      redirect_to @activity_report_application_form, notice: "Application submitted"
    else
      flash[:errors] = @activity_report_application_form.errors.full_messages
      redirect_to edit_activity_report_application_form_url(@activity_report_application_form)
    end
  end

  # DELETE /activity_report_application_forms/1 or /activity_report_application_forms/1.json
  def destroy
    @activity_report_application_form.destroy!

    respond_to do |format|
      format.html { redirect_to dashboard_path, status: :see_other, notice: "Activity report application form was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_activity_report_application_form
    @activity_report_application_form = authorize ActivityReportApplicationForm.find(params[:id])
  end

  def set_activity_report_case
    @activity_report_case = ActivityReportCase.find_by(application_form_id: @activity_report_application_form.id) if @activity_report_application_form.present?
  end

  def set_certification_case
    if params[:certification_case_id].blank?
      redirect_to dashboard_path, alert: "Cannot create activity report without a certification case"
      return
    end

    @certification_case = CertificationCase.find_by(id: params[:certification_case_id])
  end

  def default_reporting_source
    Rails.application.config.reporting_source
  end

  def reporting_source_ivaas?
    reporting_source = params[:reporting_source] || default_reporting_source
    reporting_source == "income_verification_service"
  end

  def create_activity_report
    activity_report_application_form = ActivityReportApplicationForm.find_or_create_by(certification_case_id: @certification_case.id)
    activity_report_application_form.user_id = current_user.id
    activity_report_application_form.certification = Certification.find(@certification_case.certification_id) # TODO: to be removed in future PR, leaving for compatibility
    activity_report_application_form.save!
    @activity_report_application_form = authorize activity_report_application_form
  end

  def redirect_to_ivaas
    Rails.logger.debug("Redirecting user with id #{current_user.id} to CMS Income Verification Service")
    name = Strata::Name.new(first: "Jane", last: "Doe") # TODO: get real name and remove this
    invitation = CMSIncomeVerificationService.new.create_invitation(@activity_report_application_form, name)
    redirect_to invitation.tokenized_url, allow_other_host: true
  end

  # Only allow a list of trusted parameters through.
  def activity_report_application_form_params
    permitted_params = params.require(:activity_report_application_form).permit(
      :employer_name,
      :minutes,
      reporting_periods: [],
    )

    # Convert JSON strings to hash format for YearMonth
    if permitted_params[:reporting_periods].present?
      permitted_params[:reporting_periods] = permitted_params[:reporting_periods].filter_map do |json_string|
        next if json_string.blank?

        begin
          JSON.parse(json_string).symbolize_keys
        rescue JSON::ParserError
          nil # Skip invalid JSON
        end
      end
    end

    permitted_params
  end
end

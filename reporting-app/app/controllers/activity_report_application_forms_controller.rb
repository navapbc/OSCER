# frozen_string_literal: true

class ActivityReportApplicationFormsController < ApplicationController
  before_action :set_certification
  before_action :set_activity_report_application_form, only: %i[
    show
    edit
    review
    update
    submit
    destroy
  ]
  before_action :set_certification_case, only: %i[ show ]
  before_action :authenticate_user!

  def show
  end

  def new
    @activity_report_application_form = authorize ActivityReportApplicationForm.new
  end

  # @param reporting_source [String] Override which reporting service to use ("income_verification_service", "reporting_app")
  def edit
    default_reporting_source = Rails.application.config.reporting_source
    reporting_source = params[:reporting_source] || default_reporting_source

    if reporting_source == "income_verification_service"
      puts "Redirecting user to CMS Income Verification Service"
      # We should get the name from the certification request. For now, we'll use a placeholder name
      name = Strata::Name.new(first: "Jane", last: "Doe")
      invitation = CMSIncomeVerificationService.new.create_invitation(@activity_report_application_form, name)
      redirect_to invitation.tokenized_url, allow_other_host: true
    else
      respond_to do |format|
        format.html
        format.json { render json: @activity_report_application_form.as_json }
      end
    end
  end

  def review
  end

  def create
    @activity_report_application_form = ActivityReportApplicationForm.new(activity_report_application_form_params)
    @activity_report_application_form.user_id = current_user.id
    @activity_report_application_form.certification = @certification

    authorize @activity_report_application_form

    respond_to do |format|
      if @activity_report_application_form.save
        format.html { redirect_to certification_activity_report_application_form_path(@certification, @activity_report_application_form), notice: "Activity report application form was successfully created." }
        format.json { render :show, status: :created, location: review_certification_activity_report_application_form_path(@certification, @activity_report_application_form) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity_report_application_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @activity_report_application_form.update(activity_report_application_form_params)
        format.html { redirect_to review_certification_activity_report_application_form_path(@certification, @activity_report_application_form), notice: "Activity report application form was successfully updated." }
        format.json { render :show, status: :ok, location: review_certification_activity_report_application_form_path(@certification, @activity_report_application_form) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity_report_application_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def submit
    if @activity_report_application_form.submit_application
      redirect_to certification_activity_report_application_form_path(@certification, @activity_report_application_form), notice: "Application submitted"
    else
      flash[:errors] = @activity_report_application_form.errors.full_messages
      redirect_to edit_certification_activity_report_application_form_url(@certification, @activity_report_application_form)
    end
  end

  def destroy
    @activity_report_application_form.destroy!

    respond_to do |format|
      format.html { redirect_to dashboard_path, status: :see_other, notice: "Activity report application form was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_certification
    @certification = Certification.find(params[:certification_id])
  end

  def set_activity_report_application_form
    @activity_report_application_form = authorize ActivityReportApplicationForm.find(params[:id])
  end

  def set_certification_case
    @certification_case = CertificationCase.find_by(certification_id: @activity_report_application_form.certification_id) if @activity_report_application_form.present?
  end

  def activity_report_application_form_params
    params.require(:activity_report_application_form).permit(
      :employer_name,
      :minutes,
      :reporting_period
    )
  end
end

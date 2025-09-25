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

  # GET /activity_report_application_forms/1 or /activity_report_application_forms/1.json
  def show
  end

  # GET /activity_report_application_forms/new
  def new
    @activity_report_application_form = authorize ActivityReportApplicationForm.new
  end

  # GET /activity_report_application_forms/1/edit
  #
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

  # GET /activity_report_application_forms/1/review
  def review
  end

  # POST /activity_report_application_forms or /activity_report_application_forms.json
  def create
    @activity_report_application_form = ActivityReportApplicationForm.new(activity_report_application_form_params)
    @activity_report_application_form.user_id = current_user.id

    authorize @activity_report_application_form

    respond_to do |format|
      if @activity_report_application_form.save
        format.html { redirect_to @activity_report_application_form, notice: "Activity report application form was successfully created." }
        format.json { render :show, status: :created, location: review_activity_report_application_form_path(@activity_report_application_form) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity_report_application_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_report_application_forms/1 or /activity_report_application_forms/1.json
  def update
    respond_to do |format|
      if @activity_report_application_form.update(activity_report_application_form_params)
        format.html { redirect_to review_activity_report_application_form_path(@activity_report_application_form), notice: "Activity report application form was successfully updated." }
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

  # Only allow a list of trusted parameters through.
  def activity_report_application_form_params
    params.require(:activity_report_application_form).permit(
      :employer_name,
      :minutes,
      :reporting_period
    )
  end
end

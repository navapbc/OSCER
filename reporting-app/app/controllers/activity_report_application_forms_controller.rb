class ActivityReportApplicationFormsController < ApplicationController
  before_action :set_activity_report_application_form, only: %i[
    show
    edit
    review
    update
    submit
    destroy
  ]
  before_action :authenticate_user!
  before_action :require_current_user_to_be_activity_report_application_form_user, only: %i[ show edit update submit destroy ]
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  # GET /activity_report_application_forms or /activity_report_application_forms.json
  def index
    @activity_report_application_forms = ActivityReportApplicationForm.where(user_id: current_user.id).order(created_at: :desc)
  end

  # GET /activity_report_application_forms/1 or /activity_report_application_forms/1.json
  def show
  end

  # GET /activity_report_application_forms/new
  def new
    # TODO: user shouldn't matter here, as it can not be set from the form
    # submission, but it may be a required DB parameter at some point?
    # @activity_report_application_form = ActivityReportApplicationForm.new(user_id: current_user.id)
    @activity_report_application_form = ActivityReportApplicationForm.new
  end

  # GET /activity_report_application_forms/1/edit
  def edit
    respond_to do |format|
      format.html # render edit form with existing supporting_documents
      format.json { render json: @activity_report_application_form.as_json(include: { supporting_documents: { include: :blob } }) }
    end
  end

  # GET /activity_report_application_forms/1/review
  def review
  end

  # POST /activity_report_application_forms or /activity_report_application_forms.json
  def create
    @activity_report_application_form = ActivityReportApplicationForm.new(activity_report_application_form_params)
    @activity_report_application_form.user_id = current_user.id

    respond_to do |format|
      if @activity_report_application_form.save
        format.html { redirect_to review_activity_report_application_form_path(@activity_report_application_form), notice: "Activity report application form was successfully created." }
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
      format.html { redirect_to activity_report_application_forms_path, status: :see_other, notice: "Activity report application form was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_report_application_form
      @activity_report_application_form = ActivityReportApplicationForm.find(params[:id])
    end

    def require_current_user_to_be_activity_report_application_form_user
      unless is_current_user_activity_report_application_form_user?
        redirect_to activity_report_application_forms_path, status: :unauthorized, alert: "You must be the user of this activity report application form to modify it."
      end
    end

    def is_current_user_activity_report_application_form_user?
      @activity_report_application_form.user_id == current_user.id
    end

    # Only allow a list of trusted parameters through.
    def activity_report_application_form_params
      params.require(:activity_report_application_form).permit(
        :employer_name,
        :minutes,
        :reporting_period,
        supporting_documents: []
      )
    end
end

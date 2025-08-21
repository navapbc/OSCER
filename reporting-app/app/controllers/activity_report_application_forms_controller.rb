class ActivityReportApplicationFormsController < ApplicationController
  before_action :set_activity_report_application_form, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  # GET /activity_report_application_forms or /activity_report_application_forms.json
  def index
    @activity_report_application_forms = ActivityReportApplicationForm.all
  end

  # GET /activity_report_application_forms/1 or /activity_report_application_forms/1.json
  def show
  end

  # GET /activity_report_application_forms/new
  def new
    @activity_report_application_form = ActivityReportApplicationForm.new
  end

  # GET /activity_report_application_forms/1/edit
  def edit
    respond_to do |format|
      format.html # render edit form with existing supporting_documents
      format.json { render json: @activity_report_application_form.as_json(include: { supporting_documents: { include: :blob } }) }
    end
  end

  # POST /activity_report_application_forms or /activity_report_application_forms.json
  def create
    @activity_report_application_form = ActivityReportApplicationForm.new(activity_report_application_form_params)

    respond_to do |format|
      if @activity_report_application_form.save
        format.html { redirect_to @activity_report_application_form, notice: "Activity report application form was successfully created." }
        format.json { render :show, status: :created, location: @activity_report_application_form }
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
        format.html { redirect_to @activity_report_application_form, notice: "Activity report application form was successfully updated." }
        format.json { render :show, status: :ok, location: @activity_report_application_form }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity_report_application_form.errors, status: :unprocessable_entity }
      end
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

    # Only allow a list of trusted parameters through.
    def activity_report_application_form_params
      params.require(:activity_report_application_form).permit(
        :employer_name,
        :minutes,
        supporting_documents: []
      )
    end
end

class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity_report_application_form, only: %i[ new create ]
  before_action :set_activity, only: %i[ show edit update destroy ]

  # GET /activities or /activities.json
  def index
    @activities = Activity.all
  end

  # GET /activities/1 or /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = @activity_report_application_form.activities.build
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities or /activities.json
  def create
    @activity = @activity_report_application_form.activities.build(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity.activity_report_application_form, notice: "Activity was successfully created." }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1 or /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity.activity_report_application_form, notice: "Activity was successfully updated." }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1 or /activities/1.json
  def destroy
    @activity.destroy!

    respond_to do |format|
      format.html { redirect_to activities_path, status: :see_other, notice: "Activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = authorize Activity.find(params[:id])
    end

    def set_activity_report_application_form
      @activity_report_application_form = authorize ActivityReportApplicationForm.find(params[:activity_report_application_form_id])
    end

    # Only allow a list of trusted parameters through.
    def activity_params
      params.require(:activity).permit(:activity_report_application_form_id, :month, :hours, :name)
    end
end

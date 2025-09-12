class ActivityReportCasesController < StaffController
  before_action :set_activity_report_case, only: %i[ show tasks documents notes edit update destroy ]
  before_action :set_activity_report_application_form, only: %i[ show documents ]

  # GET /activity_report_cases or /activity_report_cases.json
  def index
    @cases = ActivityReportCase.all
  end

  def closed
    @cases = ActivityReportCase.where(status: "closed").order(created_at: :desc)
    render :index
  end

  # GET /activity_report_cases/1 or /activity_report_cases/1.json
  def show
  end

  def tasks
    @tasks = @case.tasks
  end

  def documents
    @documents = @activity_report_application_form.supporting_documents
  end

  def notes
  end

  # GET /activity_report_cases/new
  def new
    @activity_report_case = ActivityReportCase.new
  end

  # GET /activity_report_cases/1/edit
  def edit
  end

  # POST /activity_report_cases or /activity_report_cases.json
  def create
    @activity_report_case = ActivityReportCase.new(activity_report_case_params)

    respond_to do |format|
      if @activity_report_case.save
        format.html { redirect_to @activity_report_case, notice: "ActivityReport case was successfully created." }
        format.json { render :show, status: :created, location: @activity_report_case }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity_report_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_report_cases/1 or /activity_report_cases/1.json
  def update
    respond_to do |format|
      if @activity_report_case.update(activity_report_case_params)
        format.html { redirect_to @activity_report_case, notice: "ActivityReport case was successfully updated." }
        format.json { render :show, status: :ok, location: @activity_report_case }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity_report_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_report_cases/1 or /activity_report_cases/1.json
  def destroy
    @activity_report_case.destroy!

    respond_to do |format|
      format.html { redirect_to activity_report_cases_path, status: :see_other, notice: "ActivityReport case was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_report_case
      @case = @activity_report_case = ActivityReportCase.find(params[:id])
    end

    def set_activity_report_application_form
      @activity_report_application_form = ActivityReportApplicationForm.find(@activity_report_case.application_form_id)
    end

    # Only allow a list of trusted parameters through.
    def activity_report_case_params
      params.fetch(:activity_report_case, {})
    end
end

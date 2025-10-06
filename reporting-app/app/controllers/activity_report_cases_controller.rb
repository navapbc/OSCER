# frozen_string_literal: true

class ActivityReportCasesController < StaffController
  before_action :set_activity_report_case, only: %i[ show tasks documents notes ]
  before_action :set_activity_report_application_form, only: %i[ show documents ]

  # GET /activity_report_cases or /activity_report_cases.json
  def index
    @cases = ActivityReportCase.all
  end

  def closed
    @cases = ActivityReportCase.closed
    render :index
  end

  # GET /activity_report_cases/1 or /activity_report_cases/1.json
  def show
  end

  def tasks
    @tasks = @case.tasks
  end

  def documents
    @documents = @activity_report_application_form.activities.map(&:supporting_documents).flatten.sort_by(&:created_at)
  end

  def notes
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_report_case
      @case = ActivityReportCase.find(params[:id])
    end

    def set_activity_report_application_form
      @activity_report_application_form = ActivityReportApplicationForm.find(@case.application_form_id)
    end
end

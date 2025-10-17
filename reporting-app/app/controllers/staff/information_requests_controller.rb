# frozen_string_literal: true

module Staff
  class InformationRequestsController < StaffController
    before_action :set_task, only: %i[ new create ]
    before_action :set_certification_case, only: %i[ new create ]

    def new
      build_information_request
    end

    def create
      build_information_request
      if @information_request.save
        redirect_to certification_case_path(@certification_case), notice: "Request for information sent."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @information_request = InformationRequest.find(params[:id])
      @task = Strata::Task.find_by(id: @information_request.task_id)
    end

    private

    def set_task
      @task = Strata::Task.find(params[:task_id]) if params[:task_id]
    end

    def set_certification_case
      @certification_case = @task.case
      @certification = Certification.find(@certification_case.certification_id)
      set_application_form
    end

    def set_application_form
      @application_form = ActivityReportApplicationForm.find_by(certification_case_id: @certification_case.id) ||
                          ExemptionApplicationForm.find_by(certification_case_id: @certification_case.id)
    end

    def build_information_request
      @information_request = information_request_class.new(information_request_params)

      @information_request.application_form_id = @application_form.id
      @information_request.application_form_type = @application_form.class.name
      @information_request.task_id = @task&.id
    end

    def information_request_class
      case @task.type
      when ReviewActivityReportTask.name
        ActivityReportInformationRequest
      when ReviewExemptionClaimTask.name
        ExemptionInformationRequest
      else
        raise StandardError, "Unknown task type #{@task.type}"
      end
    end

    def information_request_class_symbol
      information_request_class.name.underscore.to_sym
    end

    def information_request_params
      params.fetch(information_request_class_symbol, {}).permit(:staff_comment)
    end
  end
end

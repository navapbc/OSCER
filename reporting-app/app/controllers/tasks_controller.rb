# frozen_string_literal: true

class TasksController < Strata::TasksController
  def assign
    set_task
    @task.assign(current_user.id)
    flash["task-message"] = "Task assigned to you."
    redirect_to task_path(@task)
  end

  def request_information
    set_task
    @application_form = application_form_class.find_by(certification_case_id: @task.case_id)
    @information_request = information_request_class.new
    set_create_path

    render "tasks/request_information"
  end

  def create_information_request
    set_task
    result = TaskService.request_more_information(
      @task,
      information_request_params,
      information_request_class: information_request_class,
      application_form_class: application_form_class
    )

    if result[:success]
      redirect_to certification_case_path(@task.case_id), notice: "Request for information sent."
    else
      @information_request = result[:information_request_record]
      set_create_path
      render "tasks/request_information", status: :unprocessable_entity
    end
  end

  private

  def information_request_params
    params.require(information_request_class.name.underscore.to_sym).permit(:staff_comment)
  end


  protected

  def filter_tasks_by_status(tasks, status)
    status == "completed" \
        ? tasks.without_status(:pending) \
        : tasks.with_status(:pending)
  end

  def set_application_form
    @application_form = ActivityReportApplicationForm.find_by(certification_case_id: @case.id) ||
                        ExemptionApplicationForm.find_by(certification_case_id: @case.id)
  end
end

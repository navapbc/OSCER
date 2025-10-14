# frozen_string_literal: true

class TasksController < Strata::TasksController
  before_action :set_task, only: [ :assign ]
  
  def assign
    @task.assign(current_user.id)
  end
  
  protected

  def filter_tasks_by_status(tasks, status)
    status == "completed" \
        ? tasks.without_status(:pending) \
        : tasks.with_status(:pending)
  end

  private

  def set_application_form
    @application_form = ActivityReportApplicationForm.find_by(certification_case_id: @case.id) ||
                        ExemptionApplicationForm.find_by(certification_case_id: @case.id)
  end
end

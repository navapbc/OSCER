# frozen_string_literal: true

class TasksController < Strata::TasksController
  before_action :set_member, only: [ :show ]
  before_action :set_certification, only: [ :show ]

  def assign
    set_task
    @task.assign(current_user.id)
    flash["task-message"] = "Task assigned to you."
    redirect_to task_path(@task)
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

  def set_member
    @member = User.find(@application_form.user_id) if @application_form.present?
  end

  def set_certification
    @certification = @case.certification if @case.present?
  end
end

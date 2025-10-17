# frozen_string_literal: true

class TasksController < Strata::TasksController
  before_action :set_certification, only: [ :show ]
  before_action :set_member, only: [ :show ]

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
    # We do not want to grab the application form class from Certification Case
    # because it can be tied to multiple application form types
    @application_form = @task.class.application_form_class.find_by(certification_case_id: @task.case_id)
  end

  def set_certification
    @certification = Certification.find(@case.certification_id)
  end

  def set_member
    @member = Member.from_certification(@certification)
  end
end

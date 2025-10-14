# frozen_string_literal: true

class TasksController < Strata::TasksController
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

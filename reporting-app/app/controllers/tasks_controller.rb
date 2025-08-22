class TasksController < Flex::TasksController
  before_action :set_case, only: %i[ show update ]
  before_action :set_application_form, only: %i[ show update ]

  private

  def set_case
    # TODO: Flex::TasksController should automatically set the case, but can't right now
    # It should be able to after https://linear.app/nava-platform/issue/TSS-276/add-case-type-to-flex-tasks
    @case = ActivityReportCase.find(@task.case_id)
  end

  def set_application_form
    @application_form = ActivityReportApplicationForm.find(@case.application_form_id)
  end
end

class TasksController < Flex::TasksController
  def show
    super
    @kase = ActivityReportCase.find(@task.case_id)
    @application_form = ActivityReportApplicationForm.find(@kase.application_form_id)
  end
end

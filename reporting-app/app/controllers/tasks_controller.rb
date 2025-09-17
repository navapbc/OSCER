class TasksController < Flex::TasksController
  before_action :set_case, only: %i[ show update ]
  before_action :set_application_form, only: %i[ show update ]

  private

  def set_case
    case_class = @task.case_type.constantize
    @case = case_class.find(@task.case_id)
  end

  def set_application_form
    # TODO: Flex::Task should handle this
    application_form_class =
      case @case.class.name
      when "ActivityReportCase"
        ActivityReportApplicationForm
      when "ExemptionCase"
        ExemptionApplicationForm
      else
        raise "Unknown case type: #{@case.class.name}"
      end

    @application_form = application_form_class.find(@case.application_form_id)
  end
end

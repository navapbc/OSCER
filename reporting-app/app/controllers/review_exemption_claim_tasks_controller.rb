# frozen_string_literal: true

class ReviewExemptionClaimTasksController < TasksController
  def update
    kase = @task.case

    if approving_action?
      kase.accept_exemption_request
      notice = t("tasks.details.approved_message")
    elsif denying_action?
      kase.deny_exemption_request
      notice = t("tasks.details.denied_message")
    elsif information_request_action?
      # Redirect to new information request form. Task will be marked as "on hold" when
      # the information request is created.
      redirect_to(action: :request_information)
      return
    else
      raise "Invalid action"
    end

    @task.completed!

    respond_to do |format|
      format.html { redirect_to task_path(@task), notice: }
      format.json { render :show, status: :ok, location: task_path(@task) }
    end
  end

  private

  def application_form_class
    ExemptionApplicationForm
  end

  def information_request_class
    ExemptionInformationRequest
  end

  def set_create_path
    @create_path = create_information_request_review_activity_report_task_path
  end

  def approving_action?
    params[:commit] == t("tasks.details.approve_button")
  end

  def denying_action?
    params[:commit] == t("tasks.details.deny_button")
  end

  def information_request_action?
    params[:commit] == t("tasks.details.request_for_information_button")
  end
end

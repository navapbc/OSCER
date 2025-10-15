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
    end

    @task.completed!

    respond_to do |format|
      format.html { redirect_to task_path(@task), notice: }
      format.json { render :show, status: :ok, location: task_path(@task) }
    end
  end

  private

  def approving_action?
    params[:commit] == t("tasks.details.approve_button")
  end

  def denying_action?
    params[:commit] == t("tasks.details.deny_button")
  end
end

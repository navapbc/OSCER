# frozen_string_literal: true

class ReviewExemptionClaimTasksController < TasksController
  def update
    @task.completed!

    if approving_action?
      @task.approved!
    elsif denying_action?
      @task.denied!
    end

    task_complete_notice_text = approving_action? ? t("tasks.details.approved_message") : t("tasks.details.denied_message")

    respond_to do |format|
      format.html { redirect_to task_path(@task), notice: task_complete_notice_text }
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

# frozen_string_literal: true

class ReviewActivityReportTasksController < TasksController
  def update
    kase = @task.case

    if approving?
      kase.accept_activity_report
      notice = t("tasks.details.approved_message")
    elsif denying?
      kase.deny_activity_report
      notice = t("tasks.details.denied_message")
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

  def approving?
    activity_report_decision == "yes"
  end

  def denying?
    # only temporarily changed this to work with the current approve/deny setup, so that the functionality wouldn't be broken when updating the UI.
    # Other work to handle RFI should address this functionality.
    activity_report_decision == "no-not-acceptable" || activity_report_decision == "no-additional-info"
  end

  def activity_report_decision
    params.dig(:review_activity_report_task, :activity_report_decision)
  end
end

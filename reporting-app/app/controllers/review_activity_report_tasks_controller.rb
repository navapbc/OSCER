# frozen_string_literal: true

class ReviewActivityReportTasksController < TasksController
  def update
    kase = @task.case

    if is_approving
      kase.accept_activity_report
      notice = t("tasks.details.approved_message")
    elsif is_denying
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

  def is_approving
    params[:commit] == t("tasks.details.approve_button")
  end

  def is_denying
    params[:commit] == t("tasks.details.deny_button")
  end

  def task_complete_notice_text
    if @task.approved?
      t("tasks.details.approved_message")
    elsif @task.denied?
      t("tasks.details.denied_message")
    end
  end
end

class ReviewActivityReportTasksController < TasksController
  def update
    if params[:commit] == "approve"
      @task.approve
    elsif params[:commit] == "deny"
      @task.deny
    end

    respond_to do |format|
      format.html { redirect_to task_path(@task), notice: "Task completed." }
      format.json { render :show, status: :ok, location: task_path(@task) }
    end
  end
end

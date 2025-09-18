class ReviewActivityReportTasksController < TasksController
  def update
    @task.completed!

    if params[:commit] == "approve"
      @task.approved!
    elsif params[:commit] == "deny"
      @task.denied!
    end

    respond_to do |format|
      format.html { redirect_to task_path(@task), notice: "Task completed." }
      format.json { render :show, status: :ok, location: task_path(@task) }
    end
  end
end

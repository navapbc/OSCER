class ReviewActivityReportTasksController < TasksController
  def update
    @task.completed!

    if params[:commit] == "approve"
      puts "Approving activity report case:"
      puts @case.id
    else
      puts "Denying activity report case:"
      puts @case.id
    end

    respond_to do |format|
      format.html { redirect_to task_path(@task), notice: "Task completed." }
      format.json { render :show, status: :ok, location: task_path(@task) }
    end
  end
end

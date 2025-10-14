# frozen_string_literal: true

class TasksController < Strata::TasksController
  before_action :set_task, only: [ :assign ]
  
  def assign
    @task.assign(current_user.id)
  end
end

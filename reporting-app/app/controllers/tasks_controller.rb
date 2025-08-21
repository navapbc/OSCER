class TasksController < Flex::TasksController
  # TODO Remove these lines once Flex::TasksController subclasses ::StaffController
  # which should already have code for staff authentication and authorization
  before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped
end

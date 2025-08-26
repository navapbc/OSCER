class ActivityReportApplicationFormPolicy < ApplicationPolicy
  def index?
    # TODO: assuming all logged in users can create an activity report at the moment?
    user
  end

  def show?
    owning_user?
  end

  def create?
    # TODO: assuming all logged in users can create an activity report at the moment?
    user
  end

  def update?
    owning_user?
  end

  def review?
    # TODO: not nil may be more controller logic? not exactly authorization, but kinda
    owning_user? && record.submitted_at.nil?
  end

  def destroy?
    # TODO: not nil may be more controller logic? not exactly authorization, but kinda
    owning_user? && record.submitted_at.nil?
  end

  def submit?
    owning_user?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  private
    def owning_user?
      record.user_id == user.id
    end
end

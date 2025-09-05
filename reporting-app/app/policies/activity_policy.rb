class ActivityPolicy < ApplicationPolicy
  def index?
    user # any logged-in user
  end

  def show?
    owning_user?
  end

  def create?
    user # any logged-in user
  end

  def update?
    owning_user? && record.activity_report_application_form.in_progress?
  end

  def destroy?
    owning_user? && record.activity_report_application_form.in_progress?
  end

  private
    def owning_user?
      record.activity_report_application_form.user_id == user.id
    end
end

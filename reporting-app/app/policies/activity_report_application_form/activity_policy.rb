class ActivityReportApplicationForm
  class ActivityPolicy < ApplicationPolicy
    # The policy for whether a user can perform an action on an activity
    # is determined whether the user is authorized to view and edit the
    # parent activity report application form.

    def index?
      activity_report_application_form_policy.show?
    end

    def show?
      activity_report_application_form_policy.show?
    end

    def new?
      activity_report_application_form_policy.update?
    end

    def edit?
      activity_report_application_form_policy.update?
    end

    def create?
      activity_report_application_form_policy.update?
    end

    def update?
      activity_report_application_form_policy.update?
    end

    def destroy?
      activity_report_application_form_policy.update?
    end

    private
      def activity_report_application_form_policy
        activity_report_application_form, activity = record
        ActivityReportApplicationFormPolicy.new(user, activity_report_application_form)
      end
  end
end

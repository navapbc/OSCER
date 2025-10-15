# frozen_string_literal: true

class StaffController < Strata::StaffController
  before_action :authenticate_user!

  # TODO implement staff policy
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    # TODO: Move to a scope in Strata::Task
    # Strata::Task.for_assignee(current_user.id)
    @tasks = Strata::Task
      .pending
      .where(assignee_id: current_user.id)
      .includes(:case)
    cases = @tasks.map(&:case)
    certification_service.hydrate_cases_with_certifications!(cases)
  end

  protected

  def header_links
    [ { name: "Search", path: search_members_path } ] + super
  end

  def case_classes
    # Add case classes in your application
    [ CertificationCase ]
  end

  private

  def certification_service
    CertificationService.new
  end
end

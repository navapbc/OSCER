class StaffController < Strata::StaffController
  before_action :authenticate_user!

  # TODO implement staff policy
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def case_classes
    # Add case classes in your application
    [ CertificationCase ]
  end
end

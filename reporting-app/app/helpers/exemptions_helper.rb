module ExemptionsHelper
  # Returns "approved", "denied", or nil
  def exemption_case_decision(exemption_case)
    return nil if exemption_case.nil?

    decision = exemption_case.exemption_request_approval_status
    return decision if %w[approved denied].include?(decision)

    nil
  end

  # Returns one of: "approved", "denied", or "default" for the dashboard intro
  def exemption_dashboard_intro_key(exemption_case)
    exemption_case_decision(exemption_case) || "default"
  end

  # Returns state symbol for dashboard presentation
  # :no_form, :in_progress, :submitted, :case_decided
  def exemption_dashboard_state(exemption_application_form, exemption_case)
    return :no_form if exemption_application_form.nil?

    return :in_progress if exemption_application_form.respond_to?(:in_progress?) &&
                           exemption_application_form.in_progress?

    return :case_decided if exemption_case_decision(exemption_case).present?

    return :submitted if exemption_application_form.respond_to?(:submitted?) &&
                         exemption_application_form.submitted?

    :submitted
  end
end

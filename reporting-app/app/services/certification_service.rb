class CertificationService
  def save_new(certification, current_user = nil)
    if !certification.save
      return false
    end

    # TODO: not sure how else to get Rails to stop complaining about
    # :activity_report_application_forms strict loading on newly created record
    certification.activity_report_application_forms = []

    # TODO: this logic could/should be moved to an business process/event
    # processing step
    is_exempt = false
    if is_exempt
      # TODO: do something if automatically exempt
    end

    true
  end

  def member_user(certification)
    email = certification.member_email
    if not email
      return
    end

    # TODO: filter to only verified emails and/or mfa enabled ones, etc
    User.find_by(email: email)
  end

  def calculate_certification_requirements(requirement_params)
    {
      "certification_date": requirement_params[:certification_date],
      # TODO: could do something like
      # "lookback": {
      #   "start": requirement_params.certification_date.beginning_of_month << requirement_params.lookback_period,
      #   "end": requirement_params.certification_date.beginning_of_month << 1
      # },
      # but a list of the months feels potentially more usable, alt name "months_to_consider"?
      "months_that_can_be_certified": requirement_params[:lookback_period].times.map { |i| requirement_params[:certification_date].beginning_of_month << i },
      "number_of_months_to_certify": requirement_params[:number_of_months_to_certify],
      "due_date": requirement_params[:certification_date] + requirement_params[:due_period_days].days,
      "params": requirement_params.as_json
    }
  end

  def certification_type_requirement_params(certification_type)
    # TODO: can be updated to load from some config, the DB, etc.
    case certification_type
    when "new_application"
      {
        lookback_period: 1,
        number_of_months_to_certify: 1,
        due_period_days: 30
      }
    when "recertification"
      {
        lookback_period: 6,
        number_of_months_to_certify: 3,
        due_period_days: 30
      }
    end
  end
end

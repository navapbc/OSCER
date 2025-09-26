class CertificationService
  def save_new(certification, current_user = nil)
    if !certification.save
      return false
    end

    # TODO: this logic could/should be moved to an business process/event
    # processing step
    is_exempt = false
    if not is_exempt
        # TODO: for demo purposes, create an activity report associated with the
        # current user for this Certification
        b_user = bene_user(certification) || current_user
        if b_user
            activity_report = ActivityReportApplicationForm.create!(user_id: b_user.id, certification: certification)
            # due to strict loading
            certification.activity_report_application_forms = [ activity_report ]
        end
    end
  end

  def bene_user(certification)
    email = certification.beneficiary_email
    if not email
      return
    end

    # TODO: filter to only verified emails and/or mfa enabled ones, etc
    User.find_by(email: email)
  end

  # sig { params(requirement_params: Demo::Certifications::CreateForm).returns(Hash) }
  def calculate_certification_requirements(requirement_params)
    raise TypeError, "requirement_params should be a CreateForm instance" unless requirement_params.kind_of?(Demo::Certifications::CreateForm)

    {
      "certification_date": requirement_params.certification_date,
      # TODO: could do something like
      # "lookback": {
      #   "start": requirement_params.certification_date.beginning_of_month << requirement_params.lookback_period,
      #   "end": requirement_params.certification_date.beginning_of_month << 1
      # },
      # but a list of the months feels potentially more usable, alt name "months_to_consider"?
      "months_that_can_be_certified": requirement_params.lookback_period.times.map { |i| requirement_params.certification_date.beginning_of_month << i },
      "number_of_months_to_certify": requirement_params.number_of_months_to_certify,
      "due_date": requirement_params.certification_date + requirement_params.due_period_days.days,
      "params": requirement_params.attributes.as_json
    }
  end
end

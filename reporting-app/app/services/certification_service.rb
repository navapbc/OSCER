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
end

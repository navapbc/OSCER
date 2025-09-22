class CertificationService
  def save_new(certification, current_user)
    if !certification.save
      return false
    end

    # TODO: this logic could/should be moved to an business process/event
    # processing step
    is_exempt = false
    if not is_exempt
        # TODO: for demo purposes, create an activity report associated with the
        # current user for this Certification
        bene_user = current_user
        activity_report = ActivityReportApplicationForm.create!(user_id: bene_user.id, certification: certification)
        # due to strict loading
        certification.activity_report_application_forms = [ activity_report ]
    end
  end
end

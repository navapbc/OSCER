# frozen_string_literal: true

class CertificationService
  def save_new(certification, current_user = nil)
    certification.save
  end

  def find_cases_by_member_id(member_id)
    certifications_by_id = Certification.by_member_id(member_id).index_by(&:id)
    certification_cases = CertificationCase.where(certification_id: certifications_by_id.keys)
    certification_cases.each do |kase|
      kase.certification = certifications_by_id[kase.certification_id]
    end
    certification_cases
  end

  def fetch_open_cases
    hydrate_cases_with_certifications!(CertificationCase.open)
  end

  def fetch_closed_cases
    hydrate_cases_with_certifications!(CertificationCase.closed)
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

  private

  def hydrate_cases_with_certifications!(cases)
    certification_ids = cases.map(&:certification_id)
    certifications_by_id = Certification.where(id: certification_ids).index_by(&:id)
    cases.each do |kase|
      kase.certification = certifications_by_id[kase.certification_id]
    end
  end
end

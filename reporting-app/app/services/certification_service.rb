# frozen_string_literal: true

class CertificationService
  # Member certification status values
  MEMBER_CERTIFICATION_STATUSES = {
    met_requirements: "met_requirements",
    exempt: "exempt",
    pending_review: "pending_review",
    awaiting_report: "awaiting_report"
  }.freeze

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

  def fetch_cases(case_ids)
    hydrate_cases_with_certifications!(CertificationCase.find(case_ids))
  end

  def member_user(certification)
    email = certification.member_email
    if not email
      return
    end

    # TODO: filter to only verified emails and/or mfa enabled ones, etc
    User.find_by(email: email)
  end

  def certification_requirements_from_input(requirements_input)
    # if they've directly provided in a valid Certifications::Requirements, use it
    requirements = Certifications::Requirements.new_filtered(requirements_input)
    if requirements.valid?
      return requirements
    end

    # otherwise they've specified some combo of parameters we need to derive the
    # final Certification requirements from
    requirement_params = Certifications::RequirementParams.new_filtered(requirements_input)
    requirement_params.validate!(:input)

    if requirement_params.certification_type.present?
      requirement_params.with_type_params(
        self.certification_type_requirement_params(requirement_params.certification_type)
      )
    end

    self.calculate_certification_requirements(requirement_params)
  end

  def calculate_certification_requirements(requirement_params)
    return unless requirement_params.present?
    raise TypeError, "Expected instance of Certifications::RequirementParams" unless requirement_params.is_a?(Certifications::RequirementParams)

    if !requirement_params.valid?(:use)
      raise ArgumentError, "Certifications::RequirementParams instance is not valid for use: #{requirement_params.errors.full_messages}"
    end

    Certifications::Requirements.new({
      "certification_date": requirement_params.certification_date,
      "months_that_can_be_certified": requirement_params.lookback_period.times.map { |i| requirement_params.certification_date.beginning_of_month << i },
      "number_of_months_to_certify": requirement_params.number_of_months_to_certify,
      "due_date": requirement_params.due_date.present? ? requirement_params.due_date : requirement_params.certification_date + requirement_params.due_period_days.days,
      "params": requirement_params.as_json
    })
  end

  def certification_type_requirement_params(certification_type)
    # TODO: can be updated to load from some config, the DB, etc.
    case certification_type
    when "new_application"
      Certifications::RequirementTypeParams.new({
        lookback_period: 1,
        number_of_months_to_certify: 1,
        due_period_days: 30
      })
    when "recertification"
      Certifications::RequirementTypeParams.new({
        lookback_period: 6,
        number_of_months_to_certify: 3,
        due_period_days: 30
      })
    end
  end

  # Calculates the member's certification status by examining the case and related applications
  # @param certification_case [CertificationCase] The case to evaluate
  # @return [String] One of MEMBER_CERTIFICATION_STATUSES values
  def calculate_member_certification_status(certification_case)
    return MEMBER_CERTIFICATION_STATUSES[:exempt] if certification_case.exemption_request_approval_status == "approved"

    return MEMBER_CERTIFICATION_STATUSES[:met_requirements] if certification_case.activity_report_approval_status == "approved"

    if certification_case.exemption_request_approval_status == "pending" ||
       certification_case.activity_report_approval_status == "pending" ||
       has_submitted_application?(certification_case)
      return MEMBER_CERTIFICATION_STATUSES[:pending_review]
    end

    MEMBER_CERTIFICATION_STATUSES[:awaiting_report]
  end

  private

  def has_submitted_application?(certification_case)
    activity_report = ActivityReportApplicationForm.find_by(certification_case_id: certification_case.id)
    exemption = ExemptionApplicationForm.find_by(certification_case_id: certification_case.id)

    (activity_report&.submitted_at.present?) || (exemption&.submitted_at.present?)
  end

  def hydrate_cases_with_certifications!(cases)
    certification_ids = cases.map(&:certification_id)
    certifications_by_id = Certification.where(id: certification_ids).index_by(&:id)
    cases.each do |kase|
      kase.certification = certifications_by_id[kase.certification_id]
    end
  end
end

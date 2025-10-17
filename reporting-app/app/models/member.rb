# frozen_string_literal: true

# Model for a Medicaid member.
# Eventually this will be a full active record model, but for now it's just a
# placeholder.
class Member < Strata::ValueObject
  include Strata::Attributes

  strata_attribute :member_id, :string
  strata_attribute :email, :string
  strata_attribute :name, :name

  # Member status based on certification case
  # Possible values: "met_requirements", "exempt", "pending_review", "awaiting_report"
  def status
    return "awaiting_report" unless certification_case

    # Check for approved exemption
    if certification_case.exemption_request_approval_status == "approved"
      return "exempt"
    end

    # Check for approved activity report
    if certification_case.activity_report_approval_status == "approved"
      return "met_requirements"
    end

    # Check if something is pending review
    if certification_case.exemption_request_approval_status == "pending" ||
       certification_case.activity_report_approval_status == "pending" ||
       has_submitted_application?
      return "pending_review"
    end

    # Default: awaiting report
    "awaiting_report"
  end

  # Human-readable status labels
  def status_label
    case status
    when "met_requirements"
      "Met requirements"
    when "exempt"
      "Exempt"
    when "pending_review"
      "Pending review"
    when "awaiting_report"
      "Awaiting report"
    else
      status.humanize
    end
  end

  # We won't need this method once we have a full active record model for member
  def self.from_certification(certification)
    certification_case = CertificationCase.find_by(certification_id: certification.id)

    Member.new(
      member_id: certification.member_id,
      email: certification.member_email,
      name: certification.member_name
    ).tap do |member|
      member.instance_variable_set(:@certification, certification)
      member.instance_variable_set(:@certification_case, certification_case)
    end
  end

  def self.find_by_member_id(member_id)
    certification = Certification.by_member_id(member_id).last!
    Member.from_certification(certification)
  end

  def self.search_by_email(email)
    certifications = Certification.find_by_member_email(email)
    certifications.map do |certification|
      Member.from_certification(certification)
    end
  end

  private

  def certification
    @certification ||= Certification.by_member_id(member_id).last
  end

  def certification_case
    @certification_case ||= CertificationCase.find_by(certification_id: certification&.id) if certification
  end

  def has_submitted_application?
    return false unless certification_case

    # Check if they have submitted activity report or exemption
    activity_report = ActivityReportApplicationForm.find_by(certification_case_id: certification_case.id)
    exemption = ExemptionApplicationForm.find_by(certification_case_id: certification_case.id)

    (activity_report&.submitted_at.present?) || (exemption&.submitted_at.present?)
  end

  def self.certification_service
    CertificationService.new
  end
end

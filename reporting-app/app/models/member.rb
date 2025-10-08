# frozen_string_literal: true

# Model for a Medicaid member.
# Eventually this will be a full active record model, but for now it's just a
# placeholder.
class Member
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :member_id, :string
  attribute :email, :string

  def self.find_by_member_id(member_id)
    certification_cases = certification_service.find_cases_by_member_id(member_id)
    if certification_cases.empty?
      raise ActiveRecord::RecordNotFound, "Couldn't find Certification with 'member_id'= \"#{member_id}\""
    end
    [
      Member.new(member_id: member_id, email: certification_cases.last.certification.member_email),
      certification_cases
    ]
  end

  def self.search_by_email(email)
    certifications = Certification.find_by_member_email(email)
    certifications.map do |certification|
      Member.new(member_id: certification.member_id, email: certification.member_email)
    end
  end

  private

  def self.certification_service
    CertificationService.new
  end
end

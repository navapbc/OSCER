class Certification < ApplicationRecord
  attribute :beneficiary_id, :string
  attribute :case_number, :string

  attribute :certification_requirements, :jsonb
  attribute :beneficiary_data, :jsonb

  has_many :activity_report_application_forms

  default_scope { includes(:activity_report_application_forms) }

  # TODO: some of this should be required, but leaving it open at the moment
  # validates :beneficiary_id, presence: true

  # TODO: add validation for JSON columns (they should be hashes, etc)

  def beneficiary_account_email
    return unless self.beneficiary_data

    self.beneficiary_data.dig("account_email")
  end

  def self.find_by_beneficiary_account_email(email)
    where("beneficiary_data->>'account_email' = :email", email: email)
  end

  def beneficiary_contact_email
    return unless self.beneficiary_data

    self.beneficiary_data.dig("contact", "email")
  end

  def self.find_by_beneficiary_contact_email(email)
    where("beneficiary_data->'contact'->>'email' = :email", email: email)
  end

  def beneficiary_email
    self.beneficiary_account_email || self.beneficiary_contact_email
  end

  def self.find_by_beneficiary_email(email)
    self.find_by_beneficiary_account_email(email).or(self.find_by_beneficiary_contact_email(email))
  end
end

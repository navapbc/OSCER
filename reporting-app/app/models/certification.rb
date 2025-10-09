# frozen_string_literal: true

class Certification < ApplicationRecord
  attribute :member_id, :string
  attribute :case_number, :string

  attribute :certification_requirements, :jsonb
  attribute :member_data, :jsonb

  has_many :activity_report_application_forms

  default_scope { includes(:activity_report_application_forms) }

  # TODO: some of this should be required, but leaving it open at the moment
  # validates :member_id, presence: true

  # TODO: add validation for JSON columns (they should be hashes, etc)

  scope :by_member_id, ->(member_id) { where(member_id:) }

  def due_date
    Date.parse(self.certification_requirements&.dig("due_date"))
  end

  def lookback_period
    start_month = Date.parse(self.certification_requirements&.dig("months_that_can_be_certified").first)
    end_month = Date.parse(self.certification_requirements&.dig("months_that_can_be_certified").last)
    Strata::DateRange.new(
      start: start_month,
      end: end_month
    )
  end

  def member_account_email
    return unless self.member_data

    self.member_data.dig("account_email")
  end

  def self.find_by_member_account_email(email)
    where("member_data->>'account_email' = :email", email: email)
  end

  def member_contact_email
    return unless self.member_data

    self.member_data.dig("contact", "email")
  end

  def self.find_by_member_contact_email(email)
    where("member_data->'contact'->>'email' = :email", email: email)
  end

  def member_email
    self.member_account_email || self.member_contact_email
  end

  def self.find_by_member_email(email)
    self.find_by_member_account_email(email).or(self.find_by_member_contact_email(email))
  end
end

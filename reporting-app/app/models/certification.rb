# frozen_string_literal: true

require_relative "certifications/requirements"

class Certification < ApplicationRecord
  attribute :member_id, :string
  attribute :case_number, :string

  attribute :certification_requirements, Certifications::RequirementsType.new
  attribute :member_data, :jsonb

  # TODO: some of this should be required, but leaving it open at the moment
  # validates :member_id, presence: true

  # TODO: add validation for JSON columns (they should be hashes, etc)

  scope :by_member_id, ->(member_id) { where(member_id:) }

  after_create_commit do
    Strata::EventManager.publish("CertificationCreated", { certification_id: id })
  end

  # TODO: We should make certification_requirements a real model rather than just a JSON blob
  # so we can avoid needing to parse the date string
  def certification_date
    certification_date_string = self.certification_requirements&.dig("certification_date")
    return nil if certification_date_string.blank?

    Date.parse(certification_date_string)
  end

  # TODO: We should make certification_requirements a real model rather than just a JSON blob
  # so we can avoid needing to parse the date string
  def due_date
    due_date_string = self.certification_requirements&.dig("due_date")
    return nil if due_date_string.blank?

    Date.parse(due_date_string)
  end

  # TODO: We should make certification_requirements a real model rather than just a JSON blob
  # so we can avoid needing to parse the date string
  def lookback_period
    months_that_can_be_certified = self.certification_requirements&.dig("months_that_can_be_certified")
    return Strata::DateRange.new(start: nil, end: nil) if months_that_can_be_certified.blank?

    start_month_string = months_that_can_be_certified.first
    start_month = start_month_string.present? ? Date.parse(start_month_string) : nil
    end_month_string = months_that_can_be_certified.last
    end_month = end_month_string.present? ? Date.parse(end_month_string) : nil

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

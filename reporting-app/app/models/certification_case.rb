# frozen_string_literal: true

class CertificationCase < Strata::Case
  # The following attributes are inherited from Strata::Case
  # attribute :certification_id, :uuid
  # attribute :status, :integer
  # enum :status, open: 0, closed: 1
  # attribute :business_process_current_step, :string
  # attribute :facts, :jsonb

  # Don't add an ActiveRecord association since Certification
  # is a separate aggregate root and we don't want to add
  # dependencies between the aggregates at the database layer
  attr_accessor :certification

  store_accessor :facts, :activity_report_approval_status, :activity_report_approval_status_updated_at,
    :exemption_request_approval_status, :exemption_request_approval_status_updated_at

  def accept_activity_report
    self.activity_report_approval_status = "approved"
    self.activity_report_approval_status_updated_at = Time.current
    save!
  end

  def deny_activity_report
    self.activity_report_approval_status = "denied"
    self.activity_report_approval_status_updated_at = Time.current
    save!
  end

  def accept_exemption_request
    self.exemption_request_approval_status = "approved"
    self.exemption_request_approval_status_updated_at = Time.current
    save!
  end

  def deny_exemption_request
    self.exemption_request_approval_status = "denied"
    self.exemption_request_approval_status_updated_at = Time.current
    save!
  end
end

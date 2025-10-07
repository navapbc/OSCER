# frozen_string_literal: true

class CertificationCase < Strata::Case
  attribute :certification_id, :uuid

  # Don't add an ActiveRecord association since Certification
  # is a separate aggregate root and we don't want to add
  # dependencies between the aggregates at the database layer
  attr_accessor :certification

  store_accessor :facts, :certification_approval_status, :certification_approval_status_updated_at,
                 :activity_report_approval_status, :activity_report_approval_status_updated_at,
                 :exemption_request_approval_status, :exemption_request_approval_status_updated_at

  def handle_review_activity_report_task_completed(status)
    raise "Invalid status" unless [ "approved", "denied" ].include?(status)

    self.activity_report_approval_status = status
    self.activity_report_approval_status_updated_at = Time.current
    save!

    Strata::EventManager.publish("ActivityReportStatusUpdated", { case_id: id })
  end

  def handle_review_exemption_claim_task_completed(status)
    raise "Invalid status" unless [ "approved", "denied" ].include?(status)

    self.exemption_request_approval_status = status
    self.exemption_request_approval_status_updated_at = Time.current
    save!
  end
end

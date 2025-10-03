# frozen_string_literal: true

class CertificationCase < Strata::Case
  attribute :certification_id, :uuid
  attribute :status, :integer
  attribute :business_process_current_step, :string
  attribute :facts, :jsonb

  scope :active, -> {
    joins(:tasks)
      .where(strata_tasks: { status: Strata::Task.statuses[:pending] })
      .distinct
  }
end

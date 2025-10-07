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
end

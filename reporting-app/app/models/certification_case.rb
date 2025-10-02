class CertificationCase < Strata::Case
  attribute :certification_id, :uuid
  attribute :status, :integer
  attribute :business_process_current_step, :string
  attribute :facts, :jsonb
end

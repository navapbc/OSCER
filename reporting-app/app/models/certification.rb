class Certification < ApplicationRecord
  attribute :beneficiary_id, :string
  attribute :case_number, :string

  attribute :certification_requirements, :jsonb
  attribute :beneficiary_data, :jsonb

  # TODO: some of this should be required, but leaving it open at the moment
  # validates :beneficiary_id, presence: true
end

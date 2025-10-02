class Certifications::RequirementTypeParams
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :lookback_period, :integer
  attribute :number_of_months_to_certify, :integer
  attribute :due_period_days, :integer
end

require_relative "requirement_params"

class Certifications::Requirements
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :certification_date, :date
  attribute :certification_type, :string, default: nil

  # TODO: could do something like
  # "lookback": {
  #   "start": requirement_params.certification_date.beginning_of_month << requirement_params.lookback_period,
  #   "end": requirement_params.certification_date.beginning_of_month << 1
  # },
  # but a list of the months feels potentially more usable, alt name "months_to_consider"?
  attribute :months_that_can_be_certified, :array
  attribute :number_of_months_to_certify, :integer
  attribute :due_date, :date

  # input params
  attribute :params, Certifications::RequirementParamsType.new

  validates :certification_date, presence: true
  validates :months_that_can_be_certified, presence: true
  validates :number_of_months_to_certify, presence: true
  validates :due_date, presence: true
end

class Certifications::RequirementsType < ActiveRecord::Type::Json
  def cast(value)
    return nil if value.nil?

    return value if value.is_a?(Certifications::Requirements)

    puts "Casting value #{value}"

    case value
    when Hash
      hash = value.with_indifferent_access
      Certifications::Requirements.new(hash)
    else
      nil
    end
  end

  # private

  # def cast_value(value)
  #   Certifications::Requirements.new(value)
  # end
end

class Certifications::RequirementParams < Certifications::RequirementTypeParams
  attribute :certification_date, :date
  attribute :certification_type, :string, default: nil

  attribute :due_date, :date

  # TODO: require either :certification_type or all type params are required
  # TODO: either :due_date or :due_period_days is required, if :certification_type not specified
end

class Certifications::RequirementParamsType < ActiveRecord::Type::Json
  def cast(value)
    return nil if value.nil?

    return value if value.is_a?(Certifications::RequirementParams)

    case value
    when Hash
      hash = value.with_indifferent_access
      Certifications::RequirementParams.new(hash)
    else
      nil
    end
  end
end

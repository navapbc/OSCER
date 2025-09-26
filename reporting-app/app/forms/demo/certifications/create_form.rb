module Demo
  module Certifications
    class CreateForm
        include ActiveModel::Model
        include ActiveModel::Attributes
        include Flex::Attributes

        LOOKBACK_PERIOD_OPTIONS = 6.times.map { |i| [ "#{i + 1} months", i + 1 ] }
        RECERTIFICATION_FREQUENCY_OPTIONS = 6.times.map { |i| [ "#{i + 1} months", i + 1 ] }
        NUMBER_OF_MONTHS_TO_CERTIFY_OPTIONS = 6.times.map { |i| [ "#{i + 1} months", i + 1 ] }
        DUE_PERIOD_OPTIONS = [ [ "15 days", 15 ], [ "30 days", 30 ], [ "60 days", 60 ] ]

        attribute :beneficiary_email, :string
        attribute :case_number, :string

        attribute :certification_type, :string
        flex_attribute :certification_date, :us_date

        # TODO: would maybe prefer to use ISO8601 duration values here instead of integers of months
        attribute :lookback_period, :integer, default: LOOKBACK_PERIOD_OPTIONS[0][1]
        attribute :number_of_months_to_certify, :integer, default: NUMBER_OF_MONTHS_TO_CERTIFY_OPTIONS[0][1]
        # TODO: would maybe prefer to use ISO8601 duration values here instead of integers of days
        attribute :due_period_days, :integer, default: DUE_PERIOD_OPTIONS[1][1]

        attribute :ex_parte_scenario, :string

        validates :certification_date, presence: true

        # TODO: may eventually want a more custom validation with clearer error
        # message about relationship to number_of_months_to_certify
        validates :lookback_period, numericality: { greater_than_or_equal_to: Proc.new { |record| record.number_of_months_to_certify } }
    end
  end
end

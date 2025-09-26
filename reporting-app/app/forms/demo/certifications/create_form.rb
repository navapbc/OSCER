module Demo
  module Certifications
    class CreateForm
        include ActiveModel::Model
        include ActiveModel::Attributes
        include Flex::Attributes

        LOOKBACK_PERIOD_OPTIONS = (1..6).to_a
        # RECERTIFICATION_FREQUENCY_OPTIONS = (1..6).to_a
        NUMBER_OF_MONTHS_TO_CERTIFY_OPTIONS = (1..6).to_a
        DUE_PERIOD_OPTIONS = [ 15, 30, 60 ] # in days

        EX_PARTE_SCENARIO_OPTIONS = [ "No data", "Partially met work hours requirement", "Fully met work hours requirement" ]

        attribute :beneficiary_email, :string
        attribute :case_number, :string

        attribute :certification_type, :string
        flex_attribute :certification_date, :us_date

        # TODO: would maybe prefer to use ISO8601 duration values here instead of integers of months
        attribute :lookback_period, :integer, default: LOOKBACK_PERIOD_OPTIONS[0]
        attribute :number_of_months_to_certify, :integer, default: NUMBER_OF_MONTHS_TO_CERTIFY_OPTIONS[0]
        # TODO: would maybe prefer to use ISO8601 duration values here instead of integers of days
        attribute :due_period_days, :integer, default: DUE_PERIOD_OPTIONS[1]

        attribute :ex_parte_scenario, :string

        validates :certification_date, presence: true

        # TODO: may eventually want a more custom validation with clearer error
        # message about relationship to number_of_months_to_certify
        validates :lookback_period, numericality: { greater_than_or_equal_to: Proc.new { |record| record.number_of_months_to_certify } }
    end
  end
end

# frozen_string_literal: true

module Demo
  module Certifications
    class BaseCreateForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include Strata::Attributes

      CERTIFICATION_TYPE_OPTIONS = [ "new_application", "recertification" ]

      LOOKBACK_PERIOD_OPTIONS = (1..6).to_a
      NUMBER_OF_MONTHS_TO_CERTIFY_OPTIONS = (1..6).to_a
      DUE_PERIOD_OPTIONS = [ 15, 30, 60 ] # in days

      attribute :beneficiary_email, :string
      attribute :case_number, :string

      # TODO: add validation you can't set both certification_type and the other params?
      attribute :certification_type, :string

      strata_attribute :certification_date, :us_date

      # TODO: would maybe prefer to use ISO8601 duration values here instead of integers of months
      attribute :lookback_period, :integer, default: LOOKBACK_PERIOD_OPTIONS[0]
      attribute :number_of_months_to_certify, :integer, default: NUMBER_OF_MONTHS_TO_CERTIFY_OPTIONS[0]
      # TODO: would maybe prefer to use ISO8601 duration values here instead of integers of days
      attribute :due_period_days, :integer, default: DUE_PERIOD_OPTIONS[1]

      validates :certification_date, presence: true

      # TODO: may eventually want a more custom validation with clearer error
      # message about relationship to number_of_months_to_certify
      validates :lookback_period, numericality: { greater_than_or_equal_to: Proc.new { |record| record.number_of_months_to_certify } }

      def locked_type_params?
        certification_type.present?
      end
    end
  end
end

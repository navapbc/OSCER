class ActivityReportApplicationForm < Flex::ApplicationForm
  has_many_attached :supporting_documents

  flex_attribute :employer_name, :string
  flex_attribute :reporting_period, :date
end

class ExemptionApplicationForm < Flex::ApplicationForm
  ALLOWED_TYPES = [
    "Short-term Hardship",
    "Incarceration"
  ].freeze

  has_many :supporting_documents

  # default_scope { with_attached_supporting_documents }

  flex_attribute :type, :string
end

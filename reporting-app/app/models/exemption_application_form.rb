class ExemptionApplicationForm < Flex::ApplicationForm
  ALLOWED_TYPES = [
    "short_term_hardship",
    "incarceration"
  ].freeze

  has_many_attached :supporting_documents

  default_scope { with_attached_supporting_documents }

  flex_attribute :exemption_type, :string

  validates :exemption_type, inclusion: { in: ALLOWED_TYPES }
end

class ExemptionApplicationForm < Flex::ApplicationForm
  enum :exemption_type, {
    short_term_hardship: "short_term_hardship",
    incarceration: "incarceration"
  }
  validates :exemption_type, inclusion: { in: exemption_types.values }

  belongs_to :certification

  has_many_attached :supporting_documents

  default_scope { with_attached_supporting_documents }

  flex_attribute :exemption_type, :string
end

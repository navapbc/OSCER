# frozen_string_literal: true

class ExemptionApplicationForm < Strata::ApplicationForm
  belongs_to :certification_case

  enum :exemption_type, {
    short_term_hardship: "short_term_hardship",
    incarceration: "incarceration"
  }
  validates :exemption_type, inclusion: { in: exemption_types.values }

  has_many_attached :supporting_documents

  default_scope { with_attached_supporting_documents }

  strata_attribute :exemption_type, :string
end

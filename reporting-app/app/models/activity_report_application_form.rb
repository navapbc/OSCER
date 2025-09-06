class ActivityReportApplicationForm < Flex::ApplicationForm
  has_many_attached :supporting_documents
  has_many :activities, strict_loading: true, autosave: true, dependent: :destroy

  flex_attribute :employer_name, :string
  flex_attribute :minutes, :integer
  flex_attribute :reporting_period, :date

  def activities_by_id
    @activities_by_id ||= activities.index_by(&:id)
  end

  def activities_by_month
    @activities_by_month ||= activities.group_by(&:month)
  end

  default_scope { includes(:activities) }

  accepts_nested_attributes_for :activities, allow_destroy: true

  # Validation for minimum 15 minutes
  validates :minutes, on: :submit, numericality: {
    greater_than_or_equal_to: 15,
    message: "must be at least 15 minutes"
  }

  validate :minutes_must_be_quarter_hour_increments

  private

  def minutes_must_be_quarter_hour_increments
    return unless minutes.present?

    # Check if minutes is a multiple of 15 (quarter hour)
    unless (minutes % 15).zero?
      errors.add(:minutes, "must be in quarter hour increments (15, 30, 45, 60, etc.)")
    end
  end
end

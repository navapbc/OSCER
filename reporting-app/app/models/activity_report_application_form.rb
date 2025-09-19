class ActivityReportApplicationForm < Flex::ApplicationForm
  # TODO: perhaps in the future not optional?
  belongs_to :certification, optional: true
  # TODO: not sure about this, but convenience for now
  has_many :activity_report_cases, foreign_key: "application_form_id", class_name: "ActivityReportCase", strict_loading: true, dependent: :destroy

  has_many :activities, strict_loading: true, autosave: true, dependent: :destroy

  flex_attribute :reporting_period, :date

  def activities_by_id
    @activities_by_id ||= activities.index_by(&:id)
  end

  def activities_by_month
    @activities_by_month ||= activities.group_by(&:month)
  end

  default_scope { includes(:activities, :certification, :activity_report_cases) }

  accepts_nested_attributes_for :activities, allow_destroy: true
end

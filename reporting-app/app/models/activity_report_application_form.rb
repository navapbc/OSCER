# frozen_string_literal: true

class ActivityReportApplicationForm < Strata::ApplicationForm
  belongs_to :certification, optional: true
  has_many :activities, strict_loading: true, autosave: true, dependent: :destroy

  # TODO: Remove ignored_columns and the reporting_period column after next deploy
  # This is to support the migration from a single reporting_period to multiple reporting_periods
  self.ignored_columns = %w[ reporting_period ]

  strata_attribute :reporting_periods, :year_month, array: true

  def activities_by_id
    @activities_by_id ||= activities.index_by(&:id)
  end

  def activities_by_month
    @activities_by_month ||= activities.group_by(&:month)
  end

  default_scope { includes(:activities, :certification) }

  accepts_nested_attributes_for :activities, allow_destroy: true
end

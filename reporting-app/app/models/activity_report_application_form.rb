# frozen_string_literal: true

class ActivityReportApplicationForm < Strata::ApplicationForm
  belongs_to :certification, optional: true
  has_many :activities, strict_loading: true, autosave: true, dependent: :destroy

  strata_attribute :reporting_period, :date

  def activities_by_id
    @activities_by_id ||= activities.index_by(&:id)
  end

  def activities_by_month
    @activities_by_month ||= activities.group_by(&:month)
  end

  default_scope { includes(:activities, :certification) }

  accepts_nested_attributes_for :activities, allow_destroy: true

  # Override Strata::ApplicationForm#publish_submitted to include the case_id
  def publish_submitted
    kase = CertificationCase.find_by(certification_id: certification_id)
    Strata::EventManager.publish("#{self.class.name}Submitted", { case_id: kase.id })
  end
end

# frozen_string_literal: true

class InformationRequest < ApplicationRecord
  include Strata::Attributes

  has_many_attached :supporting_documents

  strata_attribute :due_date, :date

  before_create :set_due_date

  validates :staff_comment, presence: true

  scope :for_application_forms, ->(application_form_ids) { where(application_form_id: application_form_ids) }

  def to_s
    type.underscore.titleize + " - " + created_at.strftime("%B %d, %Y")
  end

  def resolved?
    member_comment.present? || supporting_documents.attached?
  end

  private

  def set_due_date
    self.due_date ||= 7.days.from_now.to_date
  end
end

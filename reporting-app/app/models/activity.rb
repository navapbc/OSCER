class Activity < ApplicationRecord
  include Flex::Attributes
  belongs_to :activity_report_application_form

  flex_attribute :month, :date
  flex_attribute :hours, :decimal
  flex_attribute :name, :string
end

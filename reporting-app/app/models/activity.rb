class Activity < ApplicationRecord
  include Flex::Attributes

  has_many_attached :supporting_documents

  default_scope { with_attached_supporting_documents }

  flex_attribute :month, :date
  flex_attribute :hours, :decimal
  flex_attribute :name, :string
end

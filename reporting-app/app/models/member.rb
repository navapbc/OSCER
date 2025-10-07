# frozen_string_literal: true

class Member < ApplicationRecord
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Strata::Attributes

  flex_attribute :member_id, :string
  flex_attribute :name, :name
  flex_attribute :email, :string
end

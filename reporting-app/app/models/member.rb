# frozen_string_literal: true

class Member < ApplicationRecord
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Strata::Attributes

  strata_attribute :member_id, :string
  strata_attribute :name, :name
  strata_attribute :email, :string

  def self.find_by_member_id(member_id)
    find_by('UPPER(member_id) = ?', member_id.to_s.upcase)
  end

  def self.find_by_email(email)
    find_by('LOWER(email) = ?', email.to_s.downcase)
  end

  scope :by_name, ->(name) { 
    return none if name.blank?

    relation = all
    relation = relation.where("LOWER(name_first) = ?", name.first.downcase) if name.first.present?
    relation = relation.where("LOWER(name_middle) = ?", name.middle.downcase) if name.middle.present?
    relation = relation.where("LOWER(name_last) = ?", name.last.downcase) if name.last.present?
    relation
  }
end

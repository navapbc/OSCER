# frozen_string_literal: true

# Model for a Medicaid member.
# Eventually this will be a full active record model, but for now it's just a
# placeholder.
class Member
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :member_id, :string
  attribute :email, :string
end

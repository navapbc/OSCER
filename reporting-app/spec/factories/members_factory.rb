# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    member_id { SecureRandom.alphanumeric(10) }
    name { build(:name, :base) }
    email { Faker::Internet.email }
  end
end

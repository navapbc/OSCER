FactoryBot.define do
  factory :member do
    member_id { SecureRandom.alphanumeric(10) }
    name { association(:name, :base) }
    email { Faker::Internet.email }
  end
end

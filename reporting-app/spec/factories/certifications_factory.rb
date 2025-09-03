FactoryBot.define do
  factory :certification do
    beneficiary_id { "MyText" }
    case_number { "MyText" }
    certification_requirements { "" }
    beneficiary_data { "" }
  end
end

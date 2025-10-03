# frozen_string_literal: true

FactoryBot.define do
  factory :certification_case do
    business_process_current_step { "review_certification" }

    initialize_with {
      certification = create(:certification)
      CertificationCase.find_or_create_by!(certification_id: certification.id)
    }
  end
end

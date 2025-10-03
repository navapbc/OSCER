# frozen_string_literal: true

FactoryBot.define do
  factory :exemption_case do
    business_process_current_step { "submit_report" }
    application_form_id { nil }
  end
end

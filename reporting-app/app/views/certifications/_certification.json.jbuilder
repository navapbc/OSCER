# frozen_string_literal: true

json.extract! certification, :id, :beneficiary_id, :case_number, :certification_requirements, :beneficiary_data, :created_at, :updated_at
# TODO decide what the canonical URL for the resource actually is
json.url api_certification_url(certification, format: :json)

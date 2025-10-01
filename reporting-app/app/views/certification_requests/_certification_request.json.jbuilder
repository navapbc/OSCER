json.extract! certification_request, :id, :beneficiary_id, :case_number, :certification_requirements, :beneficiary_data, :created_at, :updated_at
# TODO decide what the canonical URL for the resource actually is
json.url api_certification_request_url(certification_request, format: :json)

class IncomeVerificationService
  class Config < Data.define(:api_key, :base_url, :client_agency_id, :log_level)
    def self.from_env
      Config.new(
        api_key: ENV["IVAAS_API_KEY"],
        base_url: ENV["IVAAS_BASE_URL"],
        client_agency_id: ENV["IVAAS_CLIENT_AGENCY_ID"],
        log_level: Rails.configuration.log_level
      )
    end
  end

  class Invitation < Data.define(:tokenized_url, :expiration_date, :language)
  end

  def initialize(config: Config.from_env)
    @config = config
  end

  def create_invitation(activity_report_application_form, name)
    res = conn.post('/api/v1/invitations') do |req|
      req.body = {
        language: 'en',
        client_agency_id: @config.client_agency_id,
        agency_partner_metadata: {
          case_number: activity_report_application_form.id,
          first_name: name.first,
          last_name: name.last
        }
      }.to_json
    end
    res.body["expiration_date"] = DateTime.parse(res.body["expiration_date"]) if res.body["expiration_date"]
    Invitation.new(**res.body)
  end

  private

  def conn()
    Faraday.new(url: @config.base_url) do |f|
      f.request :authorization, 'Bearer', -> { @config.api_key }

      # Sets the Content-Type header to application/json on each request.
      # Also, if the request body is a Hash, it will automatically be encoded as JSON.
      f.request :json

      # Parses JSON response bodies.
      # If the response body is not valid JSON, it will raise a Faraday::ParsingError.
      f.response :json

      # Raises an error on 4xx and 5xx responses.
      f.response :raise_error

      # Logs requests and responses.
      # Don't log request header since that contains the IVaaS API key
      f.response :logger, nil, { headers: { request: false, response: true }, log_level: @config.log_level }
    end
  end
end

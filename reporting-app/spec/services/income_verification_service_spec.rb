require 'rails_helper'

RSpec.describe IncomeVerificationService do
  let(:dummy_config) { IncomeVerificationService::Config.new(api_key: 'dummy-api-key', base_url: 'https://dummy.example.com', client_agency_id: 'dummy-agency', log_level: :info) }
  subject(:service) { described_class.new(config: config) }

  describe '.Config' do
    describe '.from_env' do
      before do
        allow(ENV).to receive(:[]).with('IVAAS_API_KEY').and_return('env-api-key')
        allow(ENV).to receive(:[]).with('IVAAS_BASE_URL').and_return('https://env.example.com')
        allow(ENV).to receive(:[]).with('IVAAS_CLIENT_AGENCY_ID').and_return('env-agency')
        allow(Rails.configuration).to receive(:log_level).and_return(:debug)
      end

      it 'creates a config from environment variables' do
        config = described_class::Config.from_env
        expect(config.api_key).to eq('env-api-key')
        expect(config.base_url).to eq('https://env.example.com')
        expect(config.client_agency_id).to eq('env-agency')
        expect(config.log_level).to eq(:debug)
      end
    end
  end

  describe '#create_invitation' do
    let(:expected_request_body) do
      {
        language: 'en',
        client_agency_id: config.client_agency_id,
        agency_partner_metadata: {
          case_number: '111222',
          first_name: 'Cassian',
          last_name: 'Andor'
        }
      }
    end

    let(:api_response) do
      {
        'tokenized_url' => 'https://ivaas.example.com/invitation/token123',
        'expiration_date' => '2025-08-30T00:00:00Z',
        'language' => 'en'
      }
    end

    before do
      stub_request(:post, "#{config.base_url}/api/v1/invitations")
        .with(
          body: expected_request_body,
          headers: {
            'Authorization' => "Bearer #{config.api_key}",
            'Content-Type' => 'application/json'
          }
        )
        .to_return(
          status: 200,
          body: api_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'creates an invitation and returns an Invitation object' do
      invitation = service.create_invitation

      expect(invitation).to be_an(IncomeVerificationService::Invitation)
      expect(invitation.tokenized_url).to eq('https://ivaas.example.com/invitation/token123')
      expect(invitation.expiration_date).to eq(DateTime.parse('2025-08-30T00:00:00Z'))
      expect(invitation.language).to eq('en')
    end

    context 'when the API returns an error' do
      before do
        stub_request(:post, "#{config.base_url}/api/v1/invitations")
          .to_return(
            status: 500,
            body: { error: 'Internal Server Error' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'raises a Faraday error' do
        expect { service.create_invitation }.to raise_error(Faraday::ServerError)
      end
    end

    context 'when the API returns invalid JSON' do
      before do
        stub_request(:post, "#{config.base_url}/api/v1/invitations")
          .to_return(
            status: 200,
            body: 'Invalid JSON',
            headers: { 'Content-Type': 'application/json' }
          )
      end

      it 'raises a JSON parsing error' do
        expect { service.create_invitation }.to raise_error(Faraday::ParsingError)
      end
    end
  end
end

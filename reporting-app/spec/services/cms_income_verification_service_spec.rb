require 'rails_helper'
require 'webmock/rspec'
require 'securerandom'

RSpec.describe CMSIncomeVerificationService do
  subject(:service) { described_class.new(config: config) }

  let(:config) { CMSIncomeVerificationService::Config.new(
    api_key: SecureRandom.hex(32),
    base_url: Faker::Internet.url(path: "").sub(/http/, "https"),
    client_agency_id: Faker::Alphanumeric.alpha,
    log_level: :info
  ) }


  describe '.Config' do
    describe '.from_env' do
      before do
        allow(ENV).to receive(:[]).with('IVAAS_API_KEY').and_return('env-api-key')
        allow(ENV).to receive(:[]).with('IVAAS_BASE_URL').and_return('https://ivaas.com')
        allow(ENV).to receive(:[]).with('IVAAS_CLIENT_AGENCY_ID').and_return('env-agency')
        allow(Rails.configuration).to receive(:log_level).and_return(:debug)
      end

      it 'creates a config from environment variables' do
        config = described_class::Config.from_env
        expect(config.api_key).to eq('env-api-key')
        expect(config.base_url).to eq('https://ivaas.com')
        expect(config.client_agency_id).to eq('env-agency')
        expect(config.log_level).to eq(:debug)
      end
    end
  end

  describe '#create_invitation' do
    let(:activity_report_application_form) { create(:activity_report_application_form) }
    let(:name) { Flex::Name.new(first: 'Cassian', last: 'Andor') }

    let(:expected_request_body) do
      {
        language: 'en',
        client_agency_id: config.client_agency_id,
        agency_partner_metadata: {
          case_number: activity_report_application_form.id,
          first_name: name.first,
          last_name: name.last
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
      invitation = service.create_invitation(activity_report_application_form, name)

      expect(invitation).to be_an(CMSIncomeVerificationService::Invitation)
      expect(invitation.tokenized_url).to eq('https://ivaas.example.com/invitation/token123')
      expect(invitation.expiration_date).to eq(DateTime.parse('2025-08-30T00:00:00Z'))
      expect(invitation.language).to eq('en')
    end

    context 'when the API returns extra fields' do
      let(:api_response) do
        {
          'tokenized_url' => 'https://ivaas.example.com/invitation/token123',
          'expiration_date' => '2025-08-30T00:00:00Z',
          'language' => 'en',
          'agency_partner_metadata' => { 'extra_key' => 'extra_value' }
        }
      end

      it 'ignores the extra fields' do
        invitation = service.create_invitation(activity_report_application_form, name)

        expect(invitation).to be_an(CMSIncomeVerificationService::Invitation)
        expect(invitation.tokenized_url).to eq('https://ivaas.example.com/invitation/token123')
        expect(invitation.expiration_date).to eq(DateTime.parse('2025-08-30T00:00:00Z'))
        expect(invitation.language).to eq('en')
      end
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
        expect { service.create_invitation(activity_report_application_form, name) }.to raise_error(Faraday::ServerError)
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
        expect { service.create_invitation(activity_report_application_form, name) }.to raise_error(Faraday::ParsingError)
      end
    end
  end
end

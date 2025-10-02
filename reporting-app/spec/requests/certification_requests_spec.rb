require 'rails_helper'

RSpec.describe "/certification_requests", type: :request do
  include Warden::Test::Helpers

  let(:staff_user) { User.create!(email: "staff@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:bene_user) { User.create!(email: "bene@example.com", uid: SecureRandom.uuid, provider: "login.gov") }

  let(:valid_html_request_attributes) {
    {
      beneficiary_id: "foobar",
      beneficiary_data: "{\"account_email\": \"#{bene_user.email}\"}"
    }
  }

  let(:valid_json_request_attributes) {
    {
      beneficiary_id: "foobar",
      beneficiary_data: {
        account_email: bene_user.email
      }
    }
  }

  let(:invalid_request_attributes) {
    {
      certification_requirements: "()"
    }
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # CertificationRequestsController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  before do
    login_as staff_user
  end

  after do
    Warden.test_reset!
  end

  describe "GET /index" do
    it "renders a successful response with a CertificationRequest" do
      create(:certification_request)
      get certification_requests_url
      expect(response).to be_successful
    end

    it "renders a successful response with multiple CertificationRequests" do
      create_list(:certification_request, 10)
      get certification_requests_url
      expect(response).to be_successful
    end

    it "renders a successful response without CertificationRequests" do
      get certification_requests_url
      expect(response).to be_successful
    end
  end

  # TODO: or POST /search?
  # describe "GET /api/index" do
  #   it "renders a successful response" do
  #     create(:certification_request)
  #     get certification_requests_url, headers: valid_headers, as: :json
  #     expect(response).to be_successful
  #   end
  # end

  describe "GET /show" do
    it "renders a successful response" do
      certification_request = create(:certification_request)
      get certification_request_url(certification_request)
      expect(response).to be_successful
    end

    it "renders a successful response with invalid data" do
      certification_request = create(:certification_request, :invalid_json_data)
      get certification_request_url(certification_request)
      expect(response).to be_successful
    end

    it "renders a successful response with data" do
      certification_request = create(:certification_request, :with_certification_requirements)
      get certification_request_url(certification_request)
      expect(response).to be_successful
    end
  end

  describe "GET /api/show" do
    it "renders a successful response" do
      certification_request = create(:certification_request)
      get api_certification_request_url(certification_request)
      expect(response).to be_successful
    end

    it "renders a successful response with invalid data" do
      certification_request = create(:certification_request, :invalid_json_data)
      get api_certification_request_url(certification_request)
      expect(response).to be_successful
    end

    it "renders a successful response with data" do
      certification_request = create(:certification_request, :with_certification_requirements)
      get api_certification_request_url(certification_request)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new CertificationRequest" do
        expect {
          post certification_requests_url,
               params: { certification_request: valid_html_request_attributes }, headers: valid_headers
        }.to change(CertificationRequest, :count).by(1)
      end

      it "renders a HTML response with the new certification_request" do
        post certification_requests_url,
             params: { certification_request: valid_html_request_attributes }, headers: valid_headers
        expect(response).to have_http_status(:created)
      end
    end

    context "with no bene info" do
      it "creates a new CertificationRequest" do
        expect {
          post certification_requests_url,
               params: { certification_request: { beneficiary_id: "no_user" } }, headers: valid_headers
        }.to change(CertificationRequest, :count).by(1)
      end

      it "renders a HTML response with the new certification_request" do
        post certification_requests_url,
             params: { certification_request: { beneficiary_id: "no_user" } }, headers: valid_headers
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new CertificationRequest" do
        expect {
          post certification_requests_url,
               params: { certification_request: invalid_request_attributes }
        }.not_to change(CertificationRequest, :count)
      end

      it "renders a JSON response with errors for the new certification_request" do
        post certification_requests_url,
             params: { certification_request: invalid_request_attributes }, headers: valid_headers
        expect(response).to be_client_error
      end
    end
  end

  describe "POST /api/create" do
    context "with valid parameters" do
      it "creates a new CertificationRequest" do
        expect {
          post api_certification_requests_url,
               params: { certification_request: valid_json_request_attributes }, headers: valid_headers, as: :json
        }.to change(CertificationRequest, :count).by(1)
      end

      it "renders a JSON response with the new certification_request" do
        post api_certification_requests_url,
             params: { certification_request: valid_json_request_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with no bene info" do
      it "creates a new CertificationRequest" do
        expect {
          post certification_requests_url,
              params: { certification_request: { beneficiary_id: "no_user" } }, headers: valid_headers
        }.to change(CertificationRequest, :count).by(1)
      end
    end

    context "with no matching bene info" do
      it "creates a new CertificationRequest" do
        expect {
          post certification_requests_url,
              params: { certification_request: { beneficiary_id: "no_user", beneficiary_data: { account_email: "neverfound@foo.com" } } }, headers: valid_headers
        }.to change(CertificationRequest, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new CertificationRequest" do
        expect {
          post api_certification_requests_url,
               params: { certification_request: invalid_request_attributes }, as: :json
        }.not_to change(CertificationRequest, :count)
      end

      it "renders a JSON response with errors for the new certification_request" do
        post api_certification_requests_url,
             params: { certification_request: invalid_request_attributes }, headers: valid_headers, as: :json
        expect(response).to be_client_error
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          beneficiary_id: "updated"
        }
      }

      it "updates the requested certification_request" do
        certification_request = create(:certification_request)
        patch certification_request_url(certification_request),
              params: { certification_request: new_attributes }, headers: valid_headers, as: :json
        certification_request.reload
        expect(certification_request.beneficiary_id).to eq("updated")
      end

      it "renders a HTML response with the certification_request" do
        certification_request = create(:certification_request)
        patch certification_request_url(certification_request),
              params: { certification_request: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the certification_request" do
        certification_request = create(:certification_request)
        patch certification_request_url(certification_request),
              params: { certification_request: invalid_request_attributes }, headers: valid_headers, as: :json
        expect(response).to be_client_error
      end
    end
  end
end

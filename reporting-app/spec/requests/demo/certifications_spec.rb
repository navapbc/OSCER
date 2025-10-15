# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/demo/certifications", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "foo@example.com", uid: SecureRandom.uuid, provider: "login.gov") }

  let(:valid_request_attributes) {
    {
      member_email: "foo@example.com",
      case_number: "C-123",
      certification_date: "09/25/2025"
    }
  }

  after do
    Warden.test_reset!
  end

  describe "GET /new" do
    it "renders Generic form by default" do
      get new_demo_certification_url
      expect(response).to be_successful
    end

    it "renders New Application form" do
      get new_demo_certification_url, params: { certification_type: "new_application" }
      expect(response).to be_successful
    end

    it "renders Recertification form" do
      get new_demo_certification_url, params: { certification_type: "recertification" }
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
      it "creates a new Certification" do
        expect {
          post demo_certifications_url,
               params: {
                 demo_certifications_create_form:
                   valid_request_attributes.deep_merge(
                     build(:certification_certification_requirement_params, :with_direct_params).attributes.compact
                   )
               }
        }.to change(Certification, :count).by(1)
      end

      it "creates a new 'new_application' Certification" do
        expect {
          post demo_certifications_url,
               params: { demo_certifications_create_form: valid_request_attributes.merge({ certification_type: "new_application" }) }
        }.to change(Certification, :count).by(1)
      end

      it "creates a new 'recertification' Certification" do
        expect {
          post demo_certifications_url,
               params: { demo_certifications_create_form: valid_request_attributes.merge({ certification_type: "recertification" }) }
        }.to change(Certification, :count).by(1)
      end
  end
end

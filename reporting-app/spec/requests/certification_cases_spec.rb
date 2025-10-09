# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/staff/certification_cases", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "staff@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:certification_case) { create(:certification_case) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "GET /show" do
    it "returns http success" do
      get "/staff/certification_cases/#{certification_case.id}"
      expect(response).to have_http_status(:success)
    end

    it "assigns the requested certification case to @case" do
      get "/staff/certification_cases/#{certification_case.id}"
      expect(assigns(:case)).to eq(certification_case)
    end

    it "renders the show template" do
      get "/staff/certification_cases/#{certification_case.id}"
      expect(response).to render_template(:show)
    end

    context "when certification case does not exist" do
      it "renders the show template with a warning" do
        get "/staff/certification_cases/#{SecureRandom.uuid}"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

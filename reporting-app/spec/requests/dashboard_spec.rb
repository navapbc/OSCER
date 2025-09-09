require 'rails_helper'

RSpec.describe "/dashboard", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "test@example.com", uid: SecureRandom.uuid, provider: "login.gov") }

  let(:other_user) { User.create!(email: "test-other@example.com", uid: SecureRandom.uuid, provider: "login.gov") }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "GET /index" do
    it "renders a successful response with no forms" do
      get dashboard_path
      expect(response).to be_successful
    end
  end
end

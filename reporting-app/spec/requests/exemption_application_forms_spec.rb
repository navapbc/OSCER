require 'rails_helper'

RSpec.describe "/exemption_application_forms", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "test@example.com", uid: SecureRandom.uuid, provider: "login.gov") }

  let(:valid_attributes) {
    {
      exemption_type: "short_term_hardship"
    }
  }

  let(:existing_exemption_application_form) { create(:exemption_application_form, user_id: user.id) }

  let(:invalid_attributes) {
    {
      exemption_type: "Super Rare Exemption Type"
    }
  }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "GET /show" do
    it "renders a successful response" do
      get exemption_application_form_url(existing_exemption_application_form)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_exemption_application_form_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_exemption_application_form_url(existing_exemption_application_form)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ExemptionApplicationForm" do
        expect {
          post exemption_application_forms_url, params: { exemption_application_form: valid_attributes }
        }.to change(ExemptionApplicationForm, :count).by(1)
      end

      it "redirects to the created exemption_application_form" do
        post exemption_application_forms_url, params: { exemption_application_form: valid_attributes }
        expect(response).to redirect_to(exemption_application_form_url(ExemptionApplicationForm.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new ExemptionApplicationForm" do
        expect {
          post exemption_application_forms_url, params: { exemption_application_form: invalid_attributes }
        }.to change(ExemptionApplicationForm, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post exemption_application_forms_url, params: { exemption_application_form: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        exemption_type: "incarceration"
      }

      it "updates the requested exemption_application_form" do
        exemption_application_form = ExemptionApplicationForm.create! valid_attributes
        expect(exemption_application_form.exemption_type).to eq("short_term_hardship")
        patch exemption_application_form_url(exemption_application_form), params: { exemption_application_form: new_attributes }
        exemption_application_form.reload
        expect(exemption_application_form.exemption_type).to eq("incarceration")
      end

      it "redirects to the exemption_application_form" do
        patch exemption_application_form_url(existing_exemption_application_form), params: { exemption_application_form: new_attributes }
        existing_exemption_application_form.reload
        expect(response).to redirect_to(exemption_application_form_url(existing_exemption_application_form))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch exemption_application_form_url(existing_exemption_application_form), params: { exemption_application_form: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested exemption_application_form" do
      expect {
        delete exemption_application_form_url(existing_exemption_application_form)
      }.to change(ExemptionApplicationForm, :count).by(-1)
    end

    it "redirects to the dashboard" do
      delete exemption_application_form_url(existing_exemption_application_form)
      expect(response).to redirect_to(dashboard_path)
    end
  end
end

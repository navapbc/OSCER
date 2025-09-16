require 'rails_helper'

RSpec.describe "/staff/exemption_cases", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "test@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:exemption_application_form) { create(:exemption_application_form) }
  let(:exemption_case) { create(:exemption_case, application_form_id: exemption_application_form.id) }
  let!(:exemption_task) { create(:review_exemption_claim_task, case: exemption_case) }

  let(:closed_exemption_case) { create(:exemption_case, application_form_id: exemption_application_form.id) }
  let!(:closed_exemption_task) { create(:review_exemption_claim_task, case: closed_exemption_case) }

  before do
    login_as user

    closed_exemption_case.close
    closed_exemption_task.mark_completed
  end

  after do
    Warden.test_reset!
  end

  describe "GET /index" do
    it "returns http success" do
      get "/staff/exemption_cases"
      expect(response).to have_http_status(:success)
    end

    it "assigns all exemption cases to @cases" do
      get "/staff/exemption_cases"
      expect(assigns(:cases)).to include(exemption_case, closed_exemption_case)
    end

    it "renders the index template" do
      get "/staff/exemption_cases"
      expect(response).to render_template(:index)
    end
  end

  describe "GET /closed" do
    it "returns http success" do
      get "/staff/exemption_cases/closed"
      expect(response).to have_http_status(:success)
    end

    it "assigns only closed exemption cases to @cases" do
      get "/staff/exemption_cases/closed"
      expect(assigns(:cases)).to include(closed_exemption_case)
      expect(assigns(:cases)).not_to include(exemption_case)
    end

    it "renders the index template" do
      get "/staff/exemption_cases/closed"
      expect(response).to render_template(:index)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/staff/exemption_cases/#{exemption_case.id}"
      expect(response).to have_http_status(:success)
    end

    it "assigns the requested exemption case to @case" do
      get "/staff/exemption_cases/#{exemption_case.id}"
      expect(assigns(:case)).to eq(exemption_case)
    end

    it "renders the show template" do
      get "/staff/exemption_cases/#{exemption_case.id}"
      expect(response).to render_template(:show)
    end

    context "when exemption case does not exist" do
      it "renders the show template with a warning" do
        get "/staff/exemption_cases/#{SecureRandom.uuid}"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /tasks" do
    it "returns http success" do
      get "/staff/exemption_cases/#{exemption_case.id}/tasks"
      expect(response).to have_http_status(:success)
    end

    it "assigns the requested exemption case to @case" do
      get "/staff/exemption_cases/#{exemption_case.id}/tasks"
      expect(assigns(:case)).to eq(exemption_case)
    end

    it "renders the tasks template" do
      get "/staff/exemption_cases/#{exemption_case.id}/tasks"
      expect(response).to render_template(:tasks)
    end
  end

  describe "GET /notes" do
    it "returns http success" do
      get "/staff/exemption_cases/#{exemption_case.id}/notes"
      expect(response).to have_http_status(:success)
    end

    it "assigns the requested exemption case to @case" do
      get "/staff/exemption_cases/#{exemption_case.id}/notes"
      expect(assigns(:case)).to eq(exemption_case)
    end

    it "renders the notes template" do
      get "/staff/exemption_cases/#{exemption_case.id}/notes"
      expect(response).to render_template(:notes)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/staff/tasks", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "test@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:certification) { create(:certification) }
  let(:certification_case) { create(:certification_case, certification_id: certification.id) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "GET /show" do
    context "with CertificationCase for ActivityReportApplicationForm" do
      let!(:activity_report_application_form) { create(:activity_report_application_form, certification_id: certification.id) }
      let!(:activity_report_task) { create(:review_activity_report_task, case: certification_case) }

      it "renders a successful response and sets the correct case and application form" do
        get "/staff/tasks/#{activity_report_task.id}"
        expect(response).to be_successful
        expect(assigns(:case)).to eq(certification_case)
        expect(assigns(:certification)).to eq(certification)
        expect(assigns(:application_form)).to eq(activity_report_application_form)
      end
    end

    context "with CertificationCase for ExemptionApplicationForm" do
      let!(:exemption_application_form) { create(:exemption_application_form, certification_id: certification.id) }
      let!(:exemption_task) { create(:review_exemption_claim_task, case: certification_case) }

      it "renders a successful response and sets the correct case and application form" do
        get "/staff/tasks/#{exemption_task.id}"
        expect(response).to be_successful
        expect(assigns(:case)).to eq(certification_case)
        expect(assigns(:certification)).to eq(certification)
        expect(assigns(:application_form)).to eq(exemption_application_form)
      end
    end
  end
end

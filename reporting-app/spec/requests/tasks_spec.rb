# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/staff/tasks", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "test@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:certification_case) { create(:certification_case) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "GET /show" do
    context "with ActivityReportApplicationForm" do
      let(:activity_report_application_form) { create(:activity_report_application_form, certification_case_id: certification_case.id) }
      let(:activity_report_task) { create(:review_activity_report_task, case: certification_case) }

      before { activity_report_application_form }

      it "renders a successful response and sets the correct case and application form" do
        get "/staff/tasks/#{activity_report_task.id}"
        expect(response).to be_successful
        expect(assigns(:case)).to eq(certification_case)
        expect(assigns(:application_form)).to eq(activity_report_application_form)
        expect(assigns(:case)).to be_a(CertificationCase)
        expect(assigns(:application_form)).to be_a(ActivityReportApplicationForm)
      end
    end

    context "with ExemptionApplicationForm" do
      let(:exemption_application_form) { create(:exemption_application_form, certification_case_id: certification_case.id) }
      let(:exemption_task) { create(:review_exemption_claim_task, case: certification_case) }

      before { exemption_application_form }

      it "renders a successful response and sets the correct case and application form" do
        get "/staff/tasks/#{exemption_task.id}"
        expect(response).to be_successful
        expect(assigns(:case)).to eq(certification_case)
        expect(assigns(:application_form)).to eq(exemption_application_form)
        expect(assigns(:case)).to be_a(CertificationCase)
        expect(assigns(:application_form)).to be_a(ExemptionApplicationForm)
      end
    end
  end
end

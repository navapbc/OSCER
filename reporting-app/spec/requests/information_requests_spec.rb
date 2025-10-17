# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/information_requests", type: :request do
  include Warden::Test::Helpers

  let(:user) { create(:user) }
  let(:certification_case) { create(:certification_case) }
  let(:application_form) do
    build(
      form_type,
      certification_case_id: certification_case.id,
    )
  end

  before do
    application_form.save!
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "GET /show" do
    let(:information_request) do
      information_request_class.create(
        application_form_id: application_form.id,
        application_form_type: application_form.class.name,
        staff_comment: "Please provide more details."
      )
    end

    context "when viewing an exemption claim information request" do
      let(:form_type) { :exemption_application_form }
      let(:information_request) do
        ExemptionClaimInformationRequest.create!(
          application_form_id: application_form.id,
          application_form_type: application_form.class.name,
          staff_comment: "Please provide more details."
        )
      end

      it "renders a successful response" do
        get information_request_path(information_request)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when viewing an activity report information request" do
      let(:form_type) { :activity_report_application_form }
      let(:information_request) do
        ActivityReportInformationRequest.create!(
          application_form_id: application_form.id,
          application_form_type: application_form.class.name,
          staff_comment: "Please provide more details."
        )
      end

      it "renders a successful response" do
        get information_request_path(information_request)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # describe "GET /new" do
  #   context "when reviewing an exemption application form" do
  #     let(:form_type) { :exemption_application_form }
  #     let(:exemption_task) { create(:review_exemption_claim_task, case: certification_case) }
  #
  #     it "renders a successful response" do, skip: "Moving to tasks"
  #       get new_information_request_path(task_id: exemption_task)
  #       expect(response).to have_http_status(:ok)
  #     end
  #
  #     it "renders a sucessful resposnse without a task_id" do
  #       get new_information_request_path
  #       expect(response).to have_http_status(:ok)
  #     end
  #   end
  #
  #   context "with a review activity report claim task" do
  #     let(:form_type) { :activity_report_application_form }
  #     let(:activity_report_task) { create(:review_activity_report_task, case: certification_case) }
  #
  #     it "renders a successful response" do
  #       get new_information_request_path(task_id: activity_report_task)
  #       expect(response).to have_http_status(:ok)
  #     end
  #   end
  # end
  #
  # describe "POST /create" do
  #   let(:staff_comment) { "Need more info" }
  #
  #   context "when reviewing an exemption application form" do
  #     let(:form_type) { :exemption_application_form }
  #     let(:exemption_task) { create(:review_exemption_claim_task, case: certification_case) }
  #     let(:form_params) do
  #       {
  #         exemption_claim_information_request: {
  #           staff_comment:,
  #           application_form_id: application_form.id,
  #           application_form_type: application_form.class.name,
  #           task_id: exemption_task.id
  #         }
  #       }
  #     end
  #
  #     it "renders a successful response" do
  #       expect {
  #         post information_requests_path(params: form_params)
  #       }.to change(InformationRequest, :count).from(0).to(1)
  #       expect(response).to have_http_status(:found)
  #       expect(response).to redirect_to(certification_case_path(certification_case))
  #     end
  #
  #     it "returns a 422 response without staff_comments" do
  #       expect {
  #         post information_requests_path(
  #           params: {
  #             exemption_claim_information_request: {
  #               staff_comment: "",
  #               application_form_id: application_form.id,
  #               application_form_type: application_form.class.name,
  #               task_id: exemption_task.id
  #             }
  #           }
  #         )
  #       }.not_to change(InformationRequest, :count)
  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end
  #   end
  #
  #   context "with a review activity report claim task" do
  #     let(:form_type) { :activity_report_application_form }
  #     let(:activity_report_task) { create(:review_activity_report_task, case: certification_case) }
  #     let(:form_params) do
  #       {
  #         activity_report_information_request: {
  #           staff_comment:,
  #           application_form_id: application_form.id,
  #           application_form_type: application_form.class.name,
  #           task_id: activity_report_task.id
  #         }
  #       }
  #     end
  #
  #     it "renders a successful response" do
  #       expect {
  #         post information_requests_path(task_id: activity_report_task, params: form_params)
  #       }.to change(InformationRequest, :count).from(0).to(1)
  #       expect(response).to have_http_status(:found)
  #       expect(response).to redirect_to(certification_case_path(certification_case))
  #     end
  #   end
  # end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/review_activity_report_tasks", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "test@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:kase) { create(:certification_case, business_process_current_step: "review_activity_report") }
  let(:task) { create(:review_activity_report_task, case: kase) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "PATCH /update" do
    context "with approve action" do
      before { patch review_activity_report_task_url(task), params: { commit: I18n.t("tasks.details.approve_button") } }

      it "marks task as approved" do
        task.reload
        kase.reload

        expect(task).to be_completed
        expect(kase.activity_report_approval_status).to eq("approved")
        expect(kase.business_process_instance.current_step).to eq("end")
        expect(kase).to be_closed
      end

      it "redirects back to the task" do
        expect(response).to redirect_to(task_path(task))
      end
    end

    context "with deny action" do
      before { patch review_activity_report_task_url(task), params: { commit: I18n.t("tasks.details.deny_button") } }

      it "marks task as denied" do
        task.reload
        kase.reload

        expect(task).to be_completed
        expect(kase.activity_report_approval_status).to eq("denied")
        expect(kase.business_process_instance.current_step).to eq("end")
        expect(kase).to be_closed
      end

      it "redirects back to the task" do
        expect(response).to redirect_to(task_path(task))
      end
    end
  end
end

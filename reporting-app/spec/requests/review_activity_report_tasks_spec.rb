require 'rails_helper'

RSpec.describe "/review_activity_report_tasks", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "test@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:application_form) { create(:activity_report_application_form) }
  let(:kase) { create(:activity_report_case, application_form_id: application_form.id) }
  let(:task) { create(:review_activity_report_task, case_id: kase.id) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "PATCH /update" do
    context "with approve action" do
      it "marks task as complete" do
        patch review_activity_report_task_url(task), params: { commit: "approve" }

        task.reload
        expect(task).to be_completed
      end

      it "redirects back to the task" do
        patch review_activity_report_task_url(task), params: { commit: "approve" }
        expect(response).to redirect_to(task_path(task))
      end
    end

    context "with deny action" do
      it "marks task as complete" do
        patch review_activity_report_task_url(task), params: { commit: "deny" }

        task.reload
        expect(task).to be_completed
      end

      it "redirects back to the task" do
        patch review_activity_report_task_url(task), params: { commit: "deny" }
        expect(response).to redirect_to(task_path(task))
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/review_exemption_claim_tasks", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "test@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:certification_case) { create(:certification_case) }
  let(:task) { create(:review_exemption_claim_task, case: certification_case) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "PATCH /update" do
    context "with approve action" do
      before { patch review_exemption_claim_task_url(task), params: { commit: I18n.t("tasks.details.approve_button") } }

      it "marks task as completed" do
        task.reload
        expect(task).to be_approved
      end

      it "redirects back to the task" do
        expect(response).to redirect_to(task_path(task))
      end
    end

    context "with deny action" do
      before { patch review_exemption_claim_task_url(task), params: { commit: I18n.t("tasks.details.deny_button") } }

      it "marks task as completed" do
        task.reload
        expect(task).to be_denied
      end

      it "redirects back to the task" do
        expect(response).to redirect_to(task_path(task))
      end
    end
  end
end

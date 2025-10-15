# frozen_string_literal: true

require "rails_helper"

RSpec.describe TasksController do
  describe "GET #index" do
    let(:user) { create(:user) }
    let(:kase) { create(:certification_case) }
    let(:pending_task) { build(:review_activity_report_task, case: kase, status: :pending) }
    let(:completed_task) { build(:review_activity_report_task, case: kase, status: :completed) }

    before do
      sign_in user
      pending_task.save!
      completed_task.save!
    end

    context "when filtering by pending status" do
      before do
        get :index, params: { status: "pending" }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "includes only pending tasks" do
        expect(assigns(:tasks)).to include(pending_task)
        expect(assigns(:tasks)).not_to include(completed_task)
      end
    end

    context "when filtering by completed status" do
      before do
        get :index, params: { filter_status: "completed" }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns non-pending tasks" do
        assigned_tasks = assigns(:tasks)
        expect(assigned_tasks).not_to include(pending_task)
        expect(assigned_tasks).to include(completed_task)
      end
    end

    context "when no status parameter is provided" do
      before do
        get :index
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "defaults to showing pending tasks" do
        expect(assigns(:tasks)).to include(pending_task)
        expect(assigns(:tasks)).not_to include(completed_task)
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe TasksController do
  describe "GET #index" do
    let!(:user) { create(:user) }
    let!(:case_record) { create(:activity_report_case) }
    let!(:pending_task) { create(:review_activity_report_task, case: case_record, status: :pending) }
    let!(:completed_task) { create(:review_activity_report_task, case: case_record, status: :completed) }
    let!(:approved_task) { create(:review_activity_report_task, case: case_record, status: :approved) }
    let!(:denied_task) { create(:review_activity_report_task, case: case_record, status: :denied) }

    before do
      sign_in user
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
        expect(assigns(:tasks)).not_to include(approved_task)
        expect(assigns(:tasks)).not_to include(denied_task)
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
        expect(assigned_tasks).to include(approved_task)
        expect(assigned_tasks).to include(denied_task)
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
        expect(assigns(:tasks)).not_to include(approved_task)
        expect(assigns(:tasks)).not_to include(denied_task)
      end
    end
  end
end

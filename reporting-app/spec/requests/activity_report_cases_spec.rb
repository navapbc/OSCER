require 'rails_helper'

RSpec.describe "/staff/activity_report_cases", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "staff@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:activity_report_case) { create(:activity_report_case, :with_activities_and_documents) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "case sub-navigation pages" do
    [
      { action: "show", path_method: :activity_report_case_path, expected_content: "Case ID:", heading_id: "case-details-heading" },
      { action: "tasks", path_method: :tasks_activity_report_case_path, expected_content: "Tasks", heading_id: "case-details-heading" },
      { action: "documents", path_method: :documents_activity_report_case_path, expected_content: "Documents", heading_id: "case-details-heading" },
      { action: "notes", path_method: :notes_activity_report_case_path, expected_content: "Notes", heading_id: "case-notes-heading" }
    ].each do |test_case|
      describe "GET #{test_case[:action]}" do
        it "renders a successful response" do
          get send(test_case[:path_method], activity_report_case)
          expect(response).to be_successful
        end

        it "displays the expected page content" do
          get send(test_case[:path_method], activity_report_case)
          expect(response.body).to include(test_case[:expected_content])
          expect(response.body).to include("id=\"#{test_case[:heading_id]}\"")
        end

        it "includes the case navigation sidebar" do
          get send(test_case[:path_method], activity_report_case)
          expect(response.body).to include("Details")
          expect(response.body).to include("Tasks")
          expect(response.body).to include("Documents")
          expect(response.body).to include("Notes")
        end
      end
    end

    describe "GET show (details page)" do
      it "displays activities information when case has activities" do
        get activity_report_case_path(activity_report_case)
        expect(response.body).to include("Activities")
        expect(response.body).to include("Reporting Period")
      end
    end

    describe "GET documents" do
      it "displays documents page content" do
        get documents_activity_report_case_path(activity_report_case)
        expect(response.body).to include("Documents")
        expect(response.body).to include("No documents available")
      end
    end

    describe "GET tasks" do
      it "displays tasks page content" do
        get tasks_activity_report_case_path(activity_report_case)
        expect(response.body).to include("Tasks")
        expect(response.body).to include("No tasks available")
      end
    end

    describe "GET notes" do
      it "displays the notes textarea" do
        get notes_activity_report_case_path(activity_report_case)
        expect(response.body).to include("textarea")
        expect(response.body).to include("No notes available")
      end
    end
  end
end

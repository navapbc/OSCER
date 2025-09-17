require 'rails_helper'

RSpec.describe "/staff/activity_report_cases", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "staff@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:activity_report_case) { create(:activity_report_case) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "case sub-navigation pages" do
    [
      { action: "show", path_method: :activity_report_case_path, label: "Details" },
      { action: "tasks", path_method: :tasks_activity_report_case_path, label: "Tasks" },
      { action: "documents", path_method: :documents_activity_report_case_path, label: "Documents" },
      { action: "notes", path_method: :notes_activity_report_case_path, label: "Notes" }
    ].each do |test_case|
      it "returns a success response" do
        get send(test_case[:path_method], activity_report_case)
        expect(response).to be_successful
      end

      it "displays case #{test_case[:action]} page header" do
        get send(test_case[:path_method], activity_report_case)
        assert_select "#case-details-heading", text: test_case[:label], count: 1
      end

      it "sets the active sidenav to #{test_case[:action]}" do
        get send(test_case[:path_method], activity_report_case)
        assert_select ".usa-sidenav>.usa-sidenav__item>.usa-current", text: test_case[:label], count: 1
      end
    end
    
    describe "GET show (details page)" do
      before { get activity_report_case_path(activity_report_case) }

      it "displays activities information when case has activities" do
        expect(response.body).to include("Reporting Period")
      end
    end

    describe "GET documents" do
      it "displays documents page content when no documents" do
        get documents_activity_report_case_path(activity_report_case)

        expect(response.body).to include("No documents available")
      end

      context "when supporting documents are attached to activities" do
        let(:activity_report_case) { create(:activity_report_case, :with_activities) }

        before do
          application_form = ActivityReportApplicationForm.find(activity_report_case.application_form_id)
          application_form.activities.first.supporting_documents.attach([
            fixture_file_upload('spec/fixtures/files/test_document_1.pdf', 'application/pdf'),
            fixture_file_upload('spec/fixtures/files/test_document_2.txt', 'text/plain')
          ])
        end

        it "displays supporting documents when available" do
          get documents_activity_report_case_path(activity_report_case)

          expect(response.body).to include("Documents")
          expect(response.body).to include("test_document_1.pdf")
          expect(response.body).to include("test_document_2.txt")
        end
      end
    end

    describe "GET tasks" do
      it "displays tasks page content when no tasks" do
        activity_report_case.tasks.destroy_all

        get tasks_activity_report_case_path(activity_report_case)

        expect(response.body).to include("Tasks")
        expect(response.body).to include("No tasks available")
      end

      it "displays tasks when available" do
        _task = create(:review_activity_report_task, case: activity_report_case)

        get tasks_activity_report_case_path(activity_report_case)

        expect(response.body).to include("Tasks")
        expect(response.body).to include("Review activity report task")
      end
    end

    describe "GET notes" do
      before { get notes_activity_report_case_path(activity_report_case) }

      it "displays the notes textarea" do
        expect(response.body).to include("textarea")
        expect(response.body).to include("No notes available")
      end
    end
  end
end

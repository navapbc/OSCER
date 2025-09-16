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
    describe "GET show (details page)" do
      before { get activity_report_case_path(activity_report_case) }

      it "should return a success response" do
        expect(response).to be_successful
      end

      it "displays case details page header" do
        assert_select "#case-details-heading", text: "Details", count: 1
      end

      it "sets the active sidenav to details" do
        assert_select "ul.usa-sidenav>li.usa-sidenav__item>a.usa-current", text: "Details", count: 1
      end

      it "displays activities information when case has activities" do
        expect(response.body).to include("Reporting Period")
      end
    end

    describe "GET documents" do
      it "should return a success response" do
        get documents_activity_report_case_path(activity_report_case)

        expect(response).to be_successful
      end

      it "displays case details page header" do
        get documents_activity_report_case_path(activity_report_case)

        assert_select "#case-details-heading", text: "Documents", count: 1
      end

      it "sets the active sidenav to documents" do
        get documents_activity_report_case_path(activity_report_case)

        assert_select "ul.usa-sidenav>li.usa-sidenav__item>a.usa-current", text: "Documents", count: 1
      end

      it "displays documents page content when no documents" do
        case_without_docs = create(:activity_report_case)

        get documents_activity_report_case_path(case_without_docs)

        expect(response.body).to include("No documents available")
      end

      it "displays supporting documents when available" do
        application_form = ActivityReportApplicationForm.find(activity_report_case.application_form_id)
        application_form.activities.first.supporting_documents.attach([
          fixture_file_upload('spec/fixtures/files/test_document_1.pdf', 'application/pdf'),
          fixture_file_upload('spec/fixtures/files/test_document_2.txt', 'text/plain')
        ])

        get documents_activity_report_case_path(activity_report_case)

        expect(response.body).to include("Documents")
        expect(response.body).to include("test_document_1.pdf")
        expect(response.body).to include("test_document_2.txt")
      end
    end

    describe "GET tasks" do
      it "should return a success response" do
        get tasks_activity_report_case_path(activity_report_case)

        expect(response).to be_successful
      end

      it "displays case details page header" do
        get tasks_activity_report_case_path(activity_report_case)

        assert_select "#case-details-heading", text: "Tasks", count: 1
      end

      it "sets the active sidenav to tasks" do
        get tasks_activity_report_case_path(activity_report_case)

        assert_select "ul.usa-sidenav>li.usa-sidenav__item>a.usa-current", text: "Tasks", count: 1
      end

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

      it "should return a success response" do
        expect(response).to be_successful
      end

      it "displays notes page header" do
        assert_select "#case-notes-heading", text: "Notes", count: 1
      end

      it "sets the active sidenav to notes" do
        assert_select "ul.usa-sidenav>li.usa-sidenav__item>a.usa-current", text: "Notes", count: 1
      end

      it "displays the notes textarea" do
        expect(response.body).to include("textarea")
        expect(response.body).to include("No notes available")
      end
    end
  end
end

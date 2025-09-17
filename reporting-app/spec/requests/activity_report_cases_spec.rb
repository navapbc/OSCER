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
  end
end

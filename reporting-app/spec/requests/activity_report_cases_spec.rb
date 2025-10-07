# frozen_string_literal: true

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
      [ "show", :activity_report_case_path, "Details" ],
      [ "tasks", :tasks_activity_report_case_path, "Tasks" ],
      [ "documents", :documents_activity_report_case_path, "Documents" ],
      [ "notes", :notes_activity_report_case_path, "Notes" ]
    ].each do |action, path_method, label|
      it "returns a success response" do
        get send(path_method, activity_report_case)
        expect(response).to be_successful
      end

      it "displays case #{action} page header" do
        get send(path_method, activity_report_case)
        assert_select "#case-details-heading", text: label, count: 1
      end

      it "sets the active sidenav to #{action}" do
        get send(path_method, activity_report_case)
        assert_select ".usa-sidenav>.usa-sidenav__item>.usa-current", text: label, count: 1
      end
    end
  end
end

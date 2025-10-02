require 'rails_helper'

RSpec.describe "/staff/certification_cases", type: :request do
  include Warden::Test::Helpers

  let(:user) { User.create!(email: "staff@example.com", uid: SecureRandom.uuid, provider: "login.gov") }
  let(:certification_case) { create(:certification_case) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe "case sub-navigation pages" do
    [
      [ "show", :certification_case_path, "Details" ],
      [ "tasks", :tasks_certification_case_path, "Tasks" ],
      [ "documents", :documents_certification_case_path, "Documents" ],
      [ "notes", :notes_certification_case_path, "Notes" ]
    ].each do |action, path_method, label|
      it "returns a success response" do
        get send(path_method, certification_case)
        expect(response).to be_successful
      end

      xit "displays case #{action} page header" do
        get send(path_method, certification_case)
        assert_select "#case-details-heading", text: label, count: 1
      end

      xit "sets the active sidenav to #{action}" do
        get send(path_method, certification_case)
        assert_select ".usa-sidenav>.usa-sidenav__item>.usa-current", text: label, count: 1
      end
    end
  end
end

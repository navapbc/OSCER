# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "activity_report_application_forms/new", type: :view do
  let(:certification) { create(:certification) }

  before do
    assign(:certification, certification)
    assign(:activity_report_application_form, ActivityReportApplicationForm.new(certification: certification))
  end

  it "renders new activity_report_application_form form" do
    render

    assert_select "form[action=?][method=?]", certification_activity_report_application_forms_path(certification), "post" do
    end
  end
end

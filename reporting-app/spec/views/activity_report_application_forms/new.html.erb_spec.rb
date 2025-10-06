# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "activity_report_application_forms/new", type: :view do
  before do
    assign(:activity_report_application_form, ActivityReportApplicationForm.new())
  end

  it "renders new activity_report_application_form form" do
    render

    assert_select "form[action=?][method=?]", activity_report_application_forms_path, "post" do
    end
  end
end

require 'rails_helper'

RSpec.describe "activity_report_application_forms/show", type: :view do
  before do
    assign(:activity_report_application_form, ActivityReportApplicationForm.create!())
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Complete and submit your activity report/)
  end
end

require 'rails_helper'

RSpec.describe "dashboard/index", type: :view do
  before do
    assign(:activity_report_application_forms, [
      ActivityReportApplicationForm.create!(),
      ActivityReportApplicationForm.create!()
    ])
    assign(:in_progress_activity_reports, [
      ActivityReportApplicationForm.create!()
    ])
  end

  it "renders a list of activity_report_application_forms" do
    render
    cell_selector = 'tr'
    assert_select cell_selector, count: 5
  end
end

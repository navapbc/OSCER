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
    assign(:exemption_application_forms, [
      ExemptionApplicationForm.create!(),
      ExemptionApplicationForm.create!()
    ])
    assign(:in_progress_exemptions, [
      ExemptionApplicationForm.create!()
    ])
  end

  it "renders a list of activity_report_application_forms and exemption_application_forms" do
    render
    cell_selector = 'tr'
    assert_select cell_selector, count: 8
  end
end

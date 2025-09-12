require 'rails_helper'

RSpec.describe "dashboard/index", type: :view do
  before do
    assign(:activity_report_application_forms, [
      create(:activity_report_application_form),
      create(:activity_report_application_form)
    ])
    assign(:in_progress_activity_reports, [
      create(:activity_report_application_form)
    ])
    assign(:exemption_application_forms, [
      create(:exemption_application_form),
      create(:exemption_application_form)
    ])
    assign(:in_progress_exemptions, [
      create(:exemption_application_form)
    ])
  end

  it "renders a list of activity_report_application_forms and exemption_application_forms" do
    render
    cell_selector = 'tr'
    assert_select cell_selector, count: 8
  end
end

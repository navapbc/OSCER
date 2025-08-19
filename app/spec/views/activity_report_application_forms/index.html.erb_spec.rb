require 'rails_helper'

RSpec.describe "activity_report_application_forms/index", type: :view do
  before(:each) do
    assign(:activity_report_application_forms, [
      ActivityReportApplicationForm.create!(),
      ActivityReportApplicationForm.create!()
    ])
  end

  it "renders a list of activity_report_application_forms" do
    render
    cell_selector = 'div>p'
  end
end

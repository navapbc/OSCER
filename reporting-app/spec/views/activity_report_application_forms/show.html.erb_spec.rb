require 'rails_helper'

RSpec.describe "activity_report_application_forms/show", type: :view do
  let(:activity_report_application_form) { ActivityReportApplicationForm.create!() }

  before do
    assign(:activity_report_application_form, activity_report_application_form)

    stub_pundit_for(activity_report_application_form, edit?: true)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Complete and submit your activity report/)
  end

  it "renders link to edit when editable" do
    render
    expect(rendered).to have_link("Edit activity report", href: edit_activity_report_application_form_path(activity_report_application_form))
  end

  it "does not render link to edit when not editable" do
    stub_pundit_for(activity_report_application_form, edit?: false)

    render
    expect(rendered).to have_button("Edit activity report", disabled: true)
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "activity_report_application_forms/edit", type: :view do
  let(:certification) { create(:certification) }
  let(:activity_report_application_form) { create(:activity_report_application_form, certification: certification) }

  before do
    assign(:certification, certification)
    assign(:activity_report_application_form, activity_report_application_form)
  end

  it "renders the edit activity_report_application_form form" do
    render

    assert_select "form[action=?][method=?]", certification_activity_report_application_form_path(certification, activity_report_application_form), "post" do
    end
  end
end

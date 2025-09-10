require 'rails_helper'

RSpec.describe "exemption_application_forms/show", type: :view do
  before(:each) do
    assign(:exemption_application_form, ExemptionApplicationForm.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

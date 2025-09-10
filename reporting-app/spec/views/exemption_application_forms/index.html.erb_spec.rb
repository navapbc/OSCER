require 'rails_helper'

RSpec.describe "exemption_application_forms/index", type: :view do
  before(:each) do
    assign(:exemption_application_forms, [
      ExemptionApplicationForm.create!(),
      ExemptionApplicationForm.create!()
    ])
  end

  it "renders a list of exemption_application_forms" do
    render
    cell_selector = 'div>p'
  end
end

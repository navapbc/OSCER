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
  end

  it "renders a list of activity_report_application_forms" do
    render
    cell_selector = 'tr'
    assert_select cell_selector, count: 5
  end

  describe 'exemption_status' do
    let!(:certification) { create(:certification) }

    context 'with no current exemption application form' do
      it 'renders the status header and message' do
        render
        expect(rendered).to have_selector('p.usa-alert__text', text: 'Exemption Status:')
        expect(rendered).to have_selector('p', text: 'No current exemption')
      end
    end
  end
end

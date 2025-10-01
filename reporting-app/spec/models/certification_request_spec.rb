require 'rails_helper'

RSpec.describe CertificationRequest, type: :model do
  it "has ActivityReportApplicationForm" do
    certification_request = create(:certification_request, :with_activity_report_application_form)
    expect(certification_request.activity_report_application_forms.count).to eq(1)
  end
end

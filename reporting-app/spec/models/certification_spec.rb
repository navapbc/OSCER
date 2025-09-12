require 'rails_helper'

RSpec.describe Certification, type: :model do
  it "has ActivityReportApplicationForm" do
    certification = create(:certification, :with_activity_report_application_form)
    expect(certification.activity_report_application_forms.count).to eq(1)
  end
end

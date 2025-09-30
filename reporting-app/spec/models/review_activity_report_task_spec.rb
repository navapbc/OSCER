require 'rails_helper'

RSpec.describe ReviewActivityReportTask, type: :model do
  let(:application_form) { create(:activity_report_application_form) }
  let(:kase) { create(:activity_report_case, application_form_id: application_form.id) }

  describe "inheritance" do
    it "inherits from Strata::Task" do
      expect(described_class.superclass).to eq(Strata::Task)
    end
  end
end

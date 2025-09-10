require 'rails_helper'

RSpec.describe ExemptionApplicationForm, type: :model do
  describe "constants" do
    describe "ALLOWED_TYPES" do
      it "includes short_term_hardship and incarceration" do
        expect(described_class::ALLOWED_TYPES).to contain_exactly(
          "short_term_hardship",
          "incarceration"
        )
      end
    end
  end

  describe "attributes" do
    let(:exemption_form) { build(:exemption_application_form) }

    describe "#exemption_type" do
      it "can be set to valid types" do
        described_class::ALLOWED_TYPES.each do |type|
          exemption_form.exemption_type = type
          expect(exemption_form.exemption_type).to eq(type)
        end
      end
    end
  end
end

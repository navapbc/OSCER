# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExemptionApplicationForm, type: :model do
  describe "attributes" do
    let(:exemption_form) { build(:exemption_application_form) }

    describe "#exemption_type" do
      it "can be set to valid types" do
        described_class.exemption_types.each do |k, v|
          exemption_form.exemption_type = v
          expect(exemption_form.exemption_type).to eq(v)
        end
      end

      it "cannot be set to an invalid type" do
        exemption_form.exemption_type = "invalid_type"
        expect(exemption_form.save).to be(false)
      end
    end
  end
end

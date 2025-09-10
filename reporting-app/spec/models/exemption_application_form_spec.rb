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

  describe "associations" do
    describe "supporting_documents" do
      let(:exemption_form) { create(:exemption_application_form) }

      it "can attach multiple documents" do
        pdf_file = fixture_file_upload('spec/fixtures/files/test_document_1.pdf', 'application/pdf')
        txt_file = fixture_file_upload('spec/fixtures/files/test_document_2.txt', 'text/plain')
        
        exemption_form.supporting_documents.attach([pdf_file, txt_file])
        
        expect(exemption_form.supporting_documents.count).to eq(2)
        expect(exemption_form.supporting_documents.first.filename.to_s).to eq("test_document_1.pdf")
        expect(exemption_form.supporting_documents.second.filename.to_s).to eq("test_document_2.txt")
      end
    end
  end

  describe "default scope" do
    let!(:exemption_form_with_docs) { create(:exemption_application_form, :with_supporting_documents) }

    it "includes supporting documents by default" do
      forms = described_class.all
      
      # Check that the supporting documents are preloaded
      forms.each do |form|
        expect(form.association(:supporting_documents_attachments)).to be_loaded
      end
    end
  end
end

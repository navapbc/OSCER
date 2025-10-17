# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CertificationService do
  let(:service) { described_class.new }
  let(:open_case) { create(:certification_case) }
  let(:closed_case) { create(:certification_case, :with_closed_status) }

  before do
    open_case
    closed_case
  end

  describe '#fetch_open_cases' do
    it 'returns only open cases with their certifications hydrated' do
      result = service.fetch_open_cases

      expect(result).to contain_exactly(open_case)
    end

    it 'does not return closed cases' do
      result = service.fetch_open_cases

      expect(result).not_to include(closed_case)
    end
  end

  describe '#fetch_closed_cases' do
    it 'returns only closed cases with their certifications hydrated' do
      result = service.fetch_closed_cases

      expect(result).to contain_exactly(closed_case)
    end

    it 'does not return open cases' do
      result = service.fetch_closed_cases

      expect(result).not_to include(open_case)
    end
  end

  describe '#calculate_member_certification_status' do
    it 'returns pending_review when application has been submitted' do
      allow(service).to receive(:has_submitted_application?).and_return(true)

      result = service.calculate_member_certification_status(open_case)

      expect(result).to eq(CertificationService::MEMBER_CERTIFICATION_STATUSES[:pending_review])
    end

    it 'returns awaiting_report when there is no submitted application' do
      allow(service).to receive(:has_submitted_application?).and_return(false)

      result = service.calculate_member_certification_status(open_case)

      expect(result).to eq(CertificationService::MEMBER_CERTIFICATION_STATUSES[:awaiting_report])
    end

    it 'returns exempt when the exemption request is approved' do
      open_case.exemption_request_approval_status = "approved"

      result = service.calculate_member_certification_status(open_case)

      expect(result).to eq(CertificationService::MEMBER_CERTIFICATION_STATUSES[:exempt])
    end

    it 'returns met_requirements when the activity report is approved' do
      open_case.activity_report_approval_status = "approved"

      result = service.calculate_member_certification_status(open_case)

      expect(result).to eq(CertificationService::MEMBER_CERTIFICATION_STATUSES[:met_requirements])
    end

    it 'returns pending_review when the exemption request is pending' do
      open_case.exemption_request_approval_status = "pending"

      result = service.calculate_member_certification_status(open_case)

      expect(result).to eq(CertificationService::MEMBER_CERTIFICATION_STATUSES[:pending_review])
    end

    it 'returns pending_review when the activity report is pending' do
      open_case.activity_report_approval_status = "pending"

      result = service.calculate_member_certification_status(open_case)

      expect(result).to eq(CertificationService::MEMBER_CERTIFICATION_STATUSES[:pending_review])
    end

    it 'prioritizes exempt when both exemption and activity report are approved' do
      open_case.exemption_request_approval_status = "approved"
      open_case.activity_report_approval_status = "approved"

      result = service.calculate_member_certification_status(open_case)

      expect(result).to eq(CertificationService::MEMBER_CERTIFICATION_STATUSES[:exempt])
    end
  end
end

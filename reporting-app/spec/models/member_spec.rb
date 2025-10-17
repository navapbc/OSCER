# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member, type: :model do
  describe '.from_certification' do
    let(:member_data) do
      build(:certification_member_data, :with_full_name)
    end
    let(:certification) do
      create(:certification,
        :with_member_data_base,
        :connected_to_email,
        member_id: "MEMBER123",
        email: "test@example.com",
        member_data_base: member_data
      )
    end

    it 'creates a Member from a Certification' do
      member = Member.from_certification(certification)

      expect(member.member_id).to eq("MEMBER123")
      expect(member.email).to eq("test@example.com")
      expect(member.name).to eq("Jane Q Public Jr")
    end

    it 'loads the associated certification case' do
      certification_case = CertificationCase.find_by(certification_id: certification.id)
      member = Member.from_certification(certification)

      expect(member.send(:certification_case)).to eq(certification_case)
    end
  end

  describe '#status' do
    let(:member_data) { build(:certification_member_data, :with_full_name) }
    let(:certification) do
      create(:certification,
        :with_member_data_base,
        :connected_to_email,
        member_id: "MEMBER123",
        email: "test@example.com",
        member_data_base: member_data
      )
    end
    let(:certification_case) { CertificationCase.find_by(certification_id: certification.id) }
    let(:member) { Member.from_certification(certification) }

    context 'when no certification case exists' do
      before do
        certification_case.destroy! if certification_case
      end

      it 'returns awaiting_report' do
        expect(member.status).to eq("awaiting_report")
      end
    end

    context 'when exemption request is approved' do
      before do
        certification_case.update!(
          exemption_request_approval_status: "approved"
        )
      end

      it 'returns exempt' do
        expect(member.status).to eq("exempt")
      end
    end

    context 'when activity report is approved' do
      before do
        certification_case.update!(
          activity_report_approval_status: "approved"
        )
      end

      it 'returns met_requirements' do
        expect(member.status).to eq("met_requirements")
      end
    end

    context 'when exemption request is pending' do
      before do
        certification_case.update!(
          exemption_request_approval_status: "pending"
        )
      end

      it 'returns pending_review' do
        expect(member.status).to eq("pending_review")
      end
    end

    context 'when activity report is pending' do
      before do
        certification_case.update!(
          activity_report_approval_status: "pending"
        )
      end

      it 'returns pending_review' do
        expect(member.status).to eq("pending_review")
      end
    end

    context 'when application has been submitted' do
      before do
        create(:activity_report_application_form,
          :with_submitted_status,
          certification_case_id: certification_case.id
        )
      end

      it 'returns pending_review' do
        expect(member.status).to eq("pending_review")
      end
    end

    context 'when nothing has been submitted' do
      it 'returns awaiting_report' do
        expect(member.status).to eq("awaiting_report")
      end
    end
  end

  describe '#status_label' do
    let(:member_data) { build(:certification_member_data, :with_full_name) }
    let(:certification) do
      create(:certification,
        :with_member_data_base,
        :connected_to_email,
        member_id: "MEMBER123",
        email: "test@example.com",
        member_data_base: member_data
      )
    end
    let(:member) { Member.from_certification(certification) }

    it 'returns human-readable label for met_requirements' do
      allow(member).to receive(:status).and_return("met_requirements")
      expect(member.status_label).to eq("Met requirements")
    end

    it 'returns human-readable label for exempt' do
      allow(member).to receive(:status).and_return("exempt")
      expect(member.status_label).to eq("Exempt")
    end

    it 'returns human-readable label for pending_review' do
      allow(member).to receive(:status).and_return("pending_review")
      expect(member.status_label).to eq("Pending review")
    end

    it 'returns human-readable label for awaiting_report' do
      allow(member).to receive(:status).and_return("awaiting_report")
      expect(member.status_label).to eq("Awaiting report")
    end
  end

  describe '.find_by_member_id' do
    let(:member_data) { build(:certification_member_data, :with_full_name) }
    let!(:certification) do
      create(:certification,
        :with_member_data_base,
        :connected_to_email,
        member_id: "MEMBER123",
        email: "test@example.com",
        member_data_base: member_data
      )
    end

    it 'finds a member by member_id' do
      member = Member.find_by_member_id("MEMBER123")

      expect(member.member_id).to eq("MEMBER123")
      expect(member.email).to eq("test@example.com")
      expect(member.name).to eq("Jane Q Public Jr")
    end
  end

  describe '.search_by_email' do
    let(:member_data1) { build(:certification_member_data, :with_full_name) }
    let(:member_data2) { build(:certification_member_data, :with_name_parts) }

    let!(:certification1) do
      create(:certification,
        :with_member_data_base,
        :connected_to_email,
        member_id: "MEMBER1",
        email: "test@example.com",
        member_data_base: member_data1
      )
    end

    let!(:certification2) do
      create(:certification,
        :with_member_data_base,
        :connected_to_email,
        member_id: "MEMBER2",
        email: "test@example.com",
        member_data_base: member_data2
      )
    end

    it 'finds all members with matching email' do
      members = Member.search_by_email("test@example.com")

      expect(members.length).to eq(2)
      expect(members.map(&:member_id)).to contain_exactly("MEMBER1", "MEMBER2")
      expect(members.map(&:name)).to contain_exactly("Jane Q Public Jr", "John Doe")
    end
  end
end

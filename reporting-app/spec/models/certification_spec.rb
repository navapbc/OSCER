# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Certification, type: :model do
  describe 'after_create_commit callback' do
    it 'publishes CertificationCreated event with certification_id' do
      allow(Strata::EventManager).to receive(:publish)
      certification = build(:certification)

      certification.save!
      expect(Strata::EventManager).to have_received(:publish).with(
        'CertificationCreated',
        { certification_id: certification.id }
      )
    end
  end

  describe '#member_name' do
    context 'with structured name format' do
      it 'returns pre-constructed full name when available' do
        member_data = build(:certification_member_data, :with_full_name)
        certification = create(:certification, :with_member_data_base, member_data_base: member_data)

        expect(certification.member_name).to eq("Jane Q Public Jr")
      end

      it 'constructs name from individual parts when full name not provided' do
        member_data = build(:certification_member_data, :with_name_parts)
        certification = create(:certification, :with_member_data_base, member_data_base: member_data)

        expect(certification.member_name).to eq("John Doe")
      end

      it 'includes middle name when constructing' do
        member_data = build(:certification_member_data, :with_middle_name)
        certification = create(:certification, :with_member_data_base, member_data_base: member_data)

        expect(certification.member_name).to eq("John Q Doe")
      end

      it 'includes suffix when constructing' do
        member_data = build(:certification_member_data, :with_suffix)
        certification = create(:certification, :with_member_data_base, member_data_base: member_data)

        expect(certification.member_name).to eq("John Doe Jr")
      end

      it 'handles all name parts' do
        member_data = build(:certification_member_data)
        member_data[:name] = {
          "first" => "Jane",
          "middle" => "Marie",
          "last" => "Smith",
          "suffix" => "III"
        }
        certification = create(:certification, :with_member_data_base, member_data_base: member_data)

        expect(certification.member_name).to eq("Jane Marie Smith III")
      end
    end

    context 'when member_data is nil' do
      it 'returns nil' do
        certification = create(:certification, member_data: nil)
        expect(certification.member_name).to be_nil
      end
    end

    context 'when name hash is missing' do
      it 'returns nil' do
        certification = create(:certification, member_data: {
          "account_email" => "test@example.com"
        })
        expect(certification.member_name).to be_nil
      end
    end

    context 'when name parts are all blank' do
      it 'returns nil' do
        member_data = build(:certification_member_data)
        member_data[:name] = {
          "first" => "",
          "last" => ""
        }
        certification = create(:certification, :with_member_data_base, member_data_base: member_data)

        expect(certification.member_name).to be_nil
      end
    end
  end
end

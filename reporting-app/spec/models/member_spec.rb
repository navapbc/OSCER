require 'rails_helper'

RSpec.describe Member, type: :model do
  describe '.find_by_member_id' do
    let!(:member1) { create(:member, member_id: 'ABC123') }
    let!(:member2) { create(:member, member_id: 'def456') }

    it 'finds member by exact member_id (case insensitive)' do
      expect(Member.find_by_member_id('ABC123')).to eq(member1)
      expect(Member.find_by_member_id('abc123')).to eq(member1)
      expect(Member.find_by_member_id('DEF456')).to eq(member2)
      expect(Member.find_by_member_id('def456')).to eq(member2)
    end

    it 'returns nil when member_id not found' do
      expect(Member.find_by_member_id('NONEXISTENT')).to be_nil
    end
  end

  describe '.find_by_email' do
    let!(:member1) { create(:member, email: 'john.doe@example.com') }
    let!(:member2) { create(:member, email: 'JANE.SMITH@EXAMPLE.COM') }

    it 'finds member by exact email (case insensitive)' do
      expect(Member.find_by_email('john.doe@example.com')).to eq(member1)
      expect(Member.find_by_email('JOHN.DOE@EXAMPLE.COM')).to eq(member1)
      expect(Member.find_by_email('jane.smith@example.com')).to eq(member2)
      expect(Member.find_by_email('JANE.SMITH@EXAMPLE.COM')).to eq(member2)
    end

    it 'returns nil when email not found' do
      expect(Member.find_by_email('nonexistent@example.com')).to be_nil
    end
  end

  describe '.by_name scope' do
    # Seed data with full names
    let!(:member_full_name_1) { create(:member, name: Strata::Name.new(first: "John", middle: "Michael", last: "Smith")) }
    let!(:member_full_name_2) { create(:member, name: Strata::Name.new(first: "Jane", middle: "Elizabeth", last: "Doe")) }
    let!(:member_full_name_3) { create(:member, name: Strata::Name.new(first: "Robert", middle: "James", last: "Johnson")) }
    let!(:member_full_name_4) { create(:member, name: Strata::Name.new(first: "John", middle: "David", last: "Smith")) }
    let!(:member_full_name_5) { create(:member, name: Strata::Name.new(first: "John", middle: "Robert", last: "Smith")) }
    let(:results) { Member.by_name(name) }

    context 'with blank name' do
      let(:name) { build(:name) }

      it 'returns no members when searching with blank name' do
        expect(results.to_a).to eq([])
      end
    end

    context 'with first and last name only' do
      let(:name) { Strata::Name.new(first: "John", last: "Smith") }

      it 'finds all members matching first and last name regardless of middle name' do
        expect(results).to include(member_full_name_1)
        expect(results).to include(member_full_name_4)
        expect(results).to include(member_full_name_5)
      end

      it 'does not include members with different first or last names' do
        expect(results).not_to include(member_full_name_2)
        expect(results).not_to include(member_full_name_3)
      end
    end

    context 'with first, middle, and last name' do
      let(:name) { Strata::Name.new(first: "John", middle: "Michael", last: "Smith") }

      it 'finds only the member with exact match on all three name parts' do
        expect(results).to include(member_full_name_1)
      end

      it 'does not include members with different middle names' do
        expect(results).not_to include(member_full_name_4)
        expect(results).not_to include(member_full_name_5)
      end
    end

    context 'with last name only' do
      let(:name) { Strata::Name.new(last: "Smith") }

      it 'finds all members matching last name only' do
        expect(results).to include(member_full_name_1)
        expect(results).to include(member_full_name_4)
        expect(results).to include(member_full_name_5)
      end

      it 'does not include members with different last names' do
        expect(results).not_to include(member_full_name_2)
        expect(results).not_to include(member_full_name_3)
      end
    end

    context 'case insensitive matching' do
      let!(:name) { Strata::Name.new(first: "JOHN", middle: "Michael", last: "smith") }

      it 'finds members with case insensitive matching' do
        expect(results).to include(member_full_name_1)
      end
    end
  end
end

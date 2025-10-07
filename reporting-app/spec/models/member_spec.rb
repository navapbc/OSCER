# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member, type: :model do
  before do
    create(:member)
    create(:member)
  end

  describe '.find_by_member_id' do
    let!(:member) { create(:member, member_id: 'ABC123') }

    it 'finds member by exact member_id (case insensitive)' do
      expect(described_class.find_by_member_id('ABC123')).to eq(member)
      expect(described_class.find_by_member_id('abc123')).to eq(member)
    end

    it 'returns nil when member_id not found' do
      expect(described_class.find_by_member_id('NONEXISTENT')).to be_nil
    end
  end

  describe '.find_by_email' do
    let!(:member) { create(:member, email: 'john.doe@example.com') }

    it 'finds member by exact email (case insensitive)' do
      expect(described_class.find_by_email('john.doe@example.com')).to eq(member)
      expect(described_class.find_by_email('JOHN.DOE@EXAMPLE.COM')).to eq(member)
    end

    it 'returns nil when email not found' do
      expect(described_class.find_by_email('nonexistent@example.com')).to be_nil
    end
  end

  describe '.by_name scope' do
    # Seed data with full names
    let!(:john_michael_smith) { create(:member, name: Strata::Name.new(first: "John", middle: "Michael", last: "Smith")) }
    let!(:jane_elizabeth_doe) { create(:member, name: Strata::Name.new(first: "Jane", middle: "Elizabeth", last: "Doe")) }
    let!(:robert_james_johnson) { create(:member, name: Strata::Name.new(first: "Robert", middle: "James", last: "Johnson")) }
    let!(:john_david_smith) { create(:member, name: Strata::Name.new(first: "John", middle: "David", last: "Smith")) }
    let!(:john_robert_smith) { create(:member, name: Strata::Name.new(first: "John", middle: "Robert", last: "Smith")) }
    let(:results) { described_class.by_name(name) }

    context 'with blank name' do
      let(:name) { build(:name) }

      it 'returns no members when searching with blank name' do
        expect(results.to_a).to eq([])
      end
    end

    context 'with first and last name only' do
      let(:name) { Strata::Name.new(first: "John", last: "Smith") }

      it 'finds all members matching first and last name regardless of middle name' do
        expect(results).to include(john_michael_smith)
        expect(results).to include(john_david_smith)
        expect(results).to include(john_robert_smith)
      end

      it 'does not include members with different first or last names' do
        expect(results).not_to include(jane_elizabeth_doe)
        expect(results).not_to include(robert_james_johnson)
      end
    end

    context 'with first, middle, and last name' do
      let(:name) { Strata::Name.new(first: "John", middle: "Michael", last: "Smith") }

      it 'finds only the member with exact match on all three name parts' do
        expect(results).to include(john_michael_smith)
      end

      it 'does not include members with different middle names' do
        expect(results).not_to include(john_david_smith)
        expect(results).not_to include(john_robert_smith)
      end
    end

    context 'with last name only' do
      let(:name) { Strata::Name.new(last: "Smith") }

      it 'finds all members matching last name only' do
        expect(results).to include(john_michael_smith)
        expect(results).to include(john_david_smith)
        expect(results).to include(john_robert_smith)
      end

      it 'does not include members with different last names' do
        expect(results).not_to include(jane_elizabeth_doe)
        expect(results).not_to include(robert_james_johnson)
      end
    end

    context 'with mixed case name' do
      let!(:name) { Strata::Name.new(first: "JOHN", middle: "Michael", last: "smith") }

      it 'finds members with case insensitive matching' do
        expect(results).to include(john_michael_smith)
      end
    end
  end
end

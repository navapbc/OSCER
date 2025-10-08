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
end

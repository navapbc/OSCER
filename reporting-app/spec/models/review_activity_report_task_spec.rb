# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewActivityReportTask, type: :model do
  describe "inheritance" do
    it "inherits from Strata::Task" do
      expect(described_class.superclass).to eq(Strata::Task)
    end
  end
end

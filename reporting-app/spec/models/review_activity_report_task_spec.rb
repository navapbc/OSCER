require 'rails_helper'

RSpec.describe ReviewActivityReportTask, type: :model do
  describe "inheritance" do
    it "inherits from Flex::Task" do
      expect(described_class.superclass).to eq(Flex::Task)
    end
  end
end

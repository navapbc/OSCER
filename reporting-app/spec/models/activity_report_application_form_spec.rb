require 'rails_helper'

RSpec.describe ActivityReportApplicationForm, type: :model do
  let (:form) { create(:activity_report_application_form) }
  
  describe '#sum_of_activity_hours' do
    it 'returns the sum of all activity hours' do
      create(:activity, hours: 2.5, activity_report_application_form_id: form.id)
      create(:activity, hours: 3.0, activity_report_application_form_id: form.id)
      create(:activity, hours: 1.5, activity_report_application_form_id: form.id)
      
      form.reload
      expect(form.sum_of_activity_hours).to eq(7.0)
    end

    it 'returns 0 when there are no activities' do
      expect(form.sum_of_activity_hours).to eq(0)
    end
  end

  describe '#average_of_activity_hours_per_month' do
    it 'returns the average hours per month across all activities' do
      # Create activities in different months
      create(:activity, hours: 4.0, month: Date.new(2025, 1, 1), activity_report_application_form_id: form.id)
      create(:activity, hours: 2.0, month: Date.new(2025, 1, 1), activity_report_application_form_id: form.id)
      create(:activity, hours: 3.0, month: Date.new(2025, 2, 1), activity_report_application_form_id: form.id)

      form.reload
      # Total hours = 9.0, number of unique months = 2
      # Expected average = 9.0 / 2 = 4.5
      expect(form.average_of_activity_hours_per_month).to eq(4.5)
    end

    it 'returns 0 when there are no activities' do
      expect(form.average_of_activity_hours_per_month).to eq(0)
    end

    it 'correctly handles activities in the same month' do
      # Create multiple activities in the same month
      create(:activity, hours: 3.0, month: Date.new(2025, 1, 1), activity_report_application_form_id: form.id)
      create(:activity, hours: 2.0, month: Date.new(2025, 1, 15), activity_report_application_form_id: form.id)

      form.reload
      # Total hours = 5.0, number of unique months = 2 (since the Date objects are different instances)
      expect(form.average_of_activity_hours_per_month).to eq(2.5)
    end
  end
end

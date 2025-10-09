# frozen_string_literal: true

class RemoveActivityReportCase < ActiveRecord::Migration[7.2]
  def change
    # Merge and RUN PR to run db-reset prior to running this migration
    drop_table :activity_report_cases
  end
end

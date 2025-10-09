# frozen_string_literal: true

class CleanupDbTables < ActiveRecord::Migration[7.2]
  def up
    # Truncate all tables and reset the sequence, in this specific order to avoid foreign key constraints
    execute "TRUNCATE TABLE activities, activity_report_application_forms, exemption_application_forms," \
      "certification_cases, certifications, exemption_cases, strata_tasks, users RESTART IDENTITY CASCADE"
  end

  def down
  end
end

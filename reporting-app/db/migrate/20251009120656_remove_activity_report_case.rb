# frozen_string_literal: true

class RemoveActivityReportCase < ActiveRecord::Migration[7.2]
  def up
    # Delete tasks associated with ActivityReportCase
    execute <<-SQL
      DELETE FROM strata_tasks
      WHERE case_type = 'ActivityReportCase'
    SQL

    # Migrate data from activity_report_cases to certification_cases
    execute <<-SQL
      INSERT INTO certification_cases (
        id,
        certification_id,
        status,
        business_process_current_step,
        facts,
        created_at,
        updated_at
      )
      SELECT
        gen_random_uuid(),
        araf.certification_id,
        arc.status,
        arc.business_process_current_step,
        arc.facts,
        arc.created_at,
        arc.updated_at
      FROM activity_report_cases arc
      INNER JOIN activity_report_application_forms araf
        ON arc.application_form_id = araf.id
      WHERE araf.certification_id IS NOT NULL
    SQL

    drop_table :activity_report_cases
  end

  def down
    create_table :activity_report_cases, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :application_form_id
      t.integer :status
      t.string :business_process_current_step
      t.jsonb :facts, default: {}
      t.timestamps
    end

    # Note: This down migration cannot fully restore the original data
    # because we don't have a reliable way to map certification_cases back to
    # activity_report_application_forms
  end
end

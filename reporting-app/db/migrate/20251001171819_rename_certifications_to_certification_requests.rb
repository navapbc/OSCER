class RenameCertificationsToCertificationRequests < ActiveRecord::Migration[7.2]
  def change
    rename_table :certifications, :certification_requests

    rename_column :activity_report_application_forms, :certification_id, :certification_request_id
    rename_column :exemption_application_forms, :certification_id, :certification_request_id
  end
end

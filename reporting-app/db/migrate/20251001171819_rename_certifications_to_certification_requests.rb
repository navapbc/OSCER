class RenameCertificationsToCertificationRequests < ActiveRecord::Migration[7.2]
  def change
    rename_table :certifications, :certification_requests
  end
end

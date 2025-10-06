class AddApplicationFormIdToCertificateCases < ActiveRecord::Migration[7.2]
  def change
    add_column :certification_cases, :application_form_id, :uuid
  end
end

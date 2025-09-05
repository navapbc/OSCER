5.times do
  app_form = ActivityReportApplicationForm.create!(
    employer_name: Faker::Company.name,
    minutes: Faker::Number.between(from: 30, to: 1200).div(15) * 15, # Ensure it's a multiple of 15
    reporting_period: Date.today.prev_month.beginning_of_month
  )
  app_form.save!
  app_form.supporting_documents.attach(io: File.open(Rails.root.join("db", "seeds", "files", "site-plan.png"), "r"), filename: "site-plan.png", content_type: "image/png")
  app_form.save!
  app_form.supporting_documents.attach(io: File.open(Rails.root.join("db", "seeds", "files", "zoning_clearance.png"), "r"), filename: "zoning_clearance.png", content_type: "image/png")
  app_form.save!
  app_form.supporting_documents.attach(io: File.open(Rails.root.join("db", "seeds", "files", "menu.pdf"), "r"), filename: "menu.pdf", content_type: "application/pdf")
  app_form.save!
  app_form.supporting_documents.attach(io: File.open(Rails.root.join("db", "seeds", "files", "equipment_list.png"), "r"), filename: "equipment_list.png", content_type: "image/png")
  app_form.save!

  app_form.submit_application

  # 3.times do
  #   ReviewActivityReportTask.create!(
  #     case: ActivityReportCase.find(application_form_id: app_form.id)
  #   )
  # end
end

5.times do
  app_form = ActivityReportApplicationForm.create!(
    employer_name: Faker::Company.name,
    minutes: Faker::Number.between(from: 30, to: 1200).div(15) * 15, # Ensure it's a multiple of 15
    reporting_period: Date.today.prev_month.beginning_of_month
  )
  app_form.save!
  app_form.supporting_documents.attach(io: File.open(Rails.root.join("db", "seeds", "files", "fake_paystub.png"), "r"), filename: "fake_paystub.png", content_type: "image/png")
  app_form.save!
  app_form.supporting_documents.attach(io: File.open(Rails.root.join("db", "seeds", "files", "fake_paystub.pdf"), "r"), filename: "fake_paystub.pdf", content_type: "application/pdf")
  app_form.save!

  app_form.submit_application
end

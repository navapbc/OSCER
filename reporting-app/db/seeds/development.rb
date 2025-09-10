5.times do |index|
  app_form = ActivityReportApplicationForm.create!(
    reporting_period: Date.today.prev_month.beginning_of_month
  )
  app_form.save!

  next if index == 0 # Skip adding activities for the first form to test empty state

  app_form.activities.create!(
    name: "Community Meeting",
    month: Date.today.prev_month.beginning_of_month,
    hours: rand(1..5),
    supporting_documents: [
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "Courthouse Clerk Paystub.png", content_type: "image/png" }
    ]
  )
  app_form.activities.create!(
    name: "Outreach Event",
    month: Date.today.prev_month.beginning_of_month,
    hours: rand(1..5),
    supporting_documents: [
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.pdf")), filename: "Paystub1.pdf", content_type: "application/pdf" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "Paystub2.png", content_type: "image/png" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "Paystub3.png", content_type: "image/png" },
    ]
  )
  app_form.activities.create!(
    name: "Training Session",
    month: Date.today.prev_month.beginning_of_month,
    hours: rand(1..5),
    supporting_documents: [
      { io: File.open(Rails.root.join("db/seeds/files/fake_training_certificate.pdf")), filename: "Training Certificate.pdf", content_type: "application/pdf" }
    ]
  )
  app_form.activities.create!(
    name: "Policy Discussion",
    month: Date.today.prev_month.prev_month.beginning_of_month,
    hours: rand(1..10)
  )
  app_form.activities.create!(
    name: "Volunteer Coordination",
    month: Date.today.prev_month.prev_month.beginning_of_month,
    hours: rand(15..60),
    supporting_documents: [
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.pdf")), filename: "Administrative Paystub.pdf", content_type: "application/pdf" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.pdf")), filename: "Art Event Coordination Paystub.pdf", content_type: "application/pdf" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.pdf")), filename: "Food Bank Paystub.pdf", content_type: "application/pdf" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "Food Bank Paystub 2.png", content_type: "image/png" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "Trash Pickup Paystub.png", content_type: "image/png" },
    ]
  )
  app_form.save!


  app_form.submit_application
end

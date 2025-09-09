5.times do
  app_form = ActivityReportApplicationForm.create!(
    reporting_period: Date.today.prev_month.beginning_of_month
  )
  app_form.save!

  app_form.activities.create!(
    name: "Community Meeting",
    month: Date.today.prev_month.beginning_of_month,
    hours: rand(1..5),
    supporting_documents: [
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "a_fake_paystub.png", content_type: "image/png" }
    ]
  )
  app_form.activities.create!(
    name: "Outreach Event",
    month: Date.today.prev_month.beginning_of_month,
    hours: rand(1..5),
    supporting_documents: [
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.pdf")), filename: "fake_paystub 1.pdf", content_type: "application/pdf" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "fake_paystub 2.png", content_type: "image/png" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "fake_paystub 3.png", content_type: "image/png" },
    ]
  )
  app_form.activities.create!(
    name: "Training Session",
    month: Date.today.prev_month.beginning_of_month,
    hours: rand(1..5)
  )

  app_form.activities.create!(
    name: "Policy Discussion",
    month: Date.today.prev_month.prev_month.beginning_of_month,
    hours: rand(1..10),
    supporting_documents: [
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.pdf")), filename: "fake_paystub uno.pdf", content_type: "application/pdf" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.pdf")), filename: "fake_paystub dos.pdf", content_type: "application/pdf" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.pdf")), filename: "fake_paystub tres.pdf", content_type: "application/pdf" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "fake_paystub cuatro.png", content_type: "image/png" },
      { io: File.open(Rails.root.join("db/seeds/files/fake_paystub.png")), filename: "fake_paystub cinco.png", content_type: "image/png" },
    ]
  )
  app_form.activities.create!(
    name: "Volunteer Coordination",
    month: Date.today.prev_month.prev_month.beginning_of_month,
    hours: rand(15..60)
  )
  app_form.save!


  app_form.submit_application
end

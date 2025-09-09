5.times do
  app_form = ActivityReportApplicationForm.create!(
    reporting_period: Date.today.prev_month.beginning_of_month
  )
  app_form.save!

  app_form.submit_application
end

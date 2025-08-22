FactoryBot.define do
  factory :activity_report_application_form do
    employer_name { Faker::Company.name }
    minutes { 15*rand(1..500) }
    reporting_period { Date.new(rand(2000..Date.today.year), rand(1..12), 1) }
  end
end

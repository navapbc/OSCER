class ReviewActivityReportTask < Flex::Task
  belongs_to :case, class_name: "ActivityReportCase"
  # Add custom attributes and behavior here

  # Example:
  # attribute :custom_field, :string
  # validates :custom_field, presence: true
end

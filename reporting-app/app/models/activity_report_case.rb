class ActivityReportCase < Flex::Case
  default_scope { includes(:tasks) }
end

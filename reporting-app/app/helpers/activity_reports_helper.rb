module ActivityReportsHelper
  def activity_report_status(activity_report)
    case
    when activity_report.nil?         then :no_form
    when activity_report.in_progress? then :in_progress
    when activity_report.submitted?   then :submitted
    when activity_report.approved?    then :approved
    end
  end
end
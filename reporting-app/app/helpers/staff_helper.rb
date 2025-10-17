# frozen_string_literal: true

module StaffHelper
  def dashboard_breadcrumbs
    [
      {
        text: "Dashboard",
        link: staff_path
      }
    ]
  end

  def member_breadcrumbs(member)
    dashboard_breadcrumbs + [
      {
        text: member.name || member.email,  # Fallback to email if name not available
        link: "#"  # Placeholder link until member profile page exists
      }
    ]
  end

  def case_breadcrumbs(member, certification_case)
    member_breadcrumbs(member) + [
      {
        text: certification_case.certification&.case_number,
        link: certification_case_path(certification_case)
      }
    ]
  end

  def task_breadcrumbs(member, certification_case, task)
    case_breadcrumbs(member, certification_case) + [
      {
        text: task.class.name.humanize,
        link: task_path(task)
      }
    ]
  end
end

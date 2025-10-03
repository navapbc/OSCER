# frozen_string_literal: true

class CertificationCases::CaseRowComponent < ViewComponent::Base
  class Case
    attr_accessor :name, :case_number, :assignee, :step, :tasks, :created_at, :path

    def initialize(certification_case:, certification:, path:)
      # TODO: Once we're collecting the name, use the actual name rather than the email
      @name = certification.beneficiary_account_email
      @case_number = certification.case_number
      @assignee = nil
      @step = certification_case.business_process_instance.current_step
      @tasks = certification_case.tasks
      @created_at = certification_case.created_at
      @path = path
    end
  end

  def initialize(kase:, path_func:)
    @case = kase
    @path_func = path_func
  end

  def self.headers
    [
      t(".name"),
      t(".case_number"),
      t(".assignee"),
      t(".step"),
      t(".due_on"),
      t(".created_at")
    ]
  end

  private

  def due_on(kase)
    pending_tasks_with_due_date = kase.tasks.select { |task| task.pending? && task.due_on.present? }
    pending_tasks_with_due_date.map(&:due_on).min&.strftime("%m/%d/%Y") || "—"
  end
end

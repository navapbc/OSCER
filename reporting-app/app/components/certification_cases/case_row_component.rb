# frozen_string_literal: true

class CertificationCases::CaseRowComponent < Strata::Cases::CaseRowComponent
  def initialize(kase:, path_func:)
    @case = kase
    @path_func = path_func
  end

  def self.columns
    [
      :name,
      :case_no,
      :assigned_to,
      :step,
      :due_on,
      :created_at
    ]
  end

  protected

  def name
    # TODO: Once we're collecting the name, use the actual name rather than the email
    @case.certification.beneficiary_account_email
  end

  def case_no
    link_to @case.certification.case_number, certification_case_path(@case)
  end
end

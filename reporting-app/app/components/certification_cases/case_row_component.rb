# frozen_string_literal: true

class CertificationCases::CaseRowComponent < Strata::Cases::CaseRowComponent
  def self.columns
    [:name] + super
  end

  protected

  def name
    # TODO: Once we're collecting the name, use the actual name rather than the email
    @case.certification.beneficiary_account_email
  end

  # Override default behavior to show the case number from the
  # certification request rather than the case.id UUID
  def case_no
    link_to @case.certification.case_number, @path_func.call(@case)
  end
end

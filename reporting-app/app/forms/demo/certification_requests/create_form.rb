module Demo
  module CertificationRequests
    class CreateForm < BaseCreateForm
      EX_PARTE_SCENARIO_OPTIONS = [ "No data", "Partially met work hours requirement", "Fully met work hours requirement" ]

      attribute :ex_parte_scenario, :string
    end
  end
end

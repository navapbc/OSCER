# frozen_string_literal: true

class CertificationBusinessProcess < Strata::BusinessProcess
  start("certification_created", on: "CertificationCreated") do |event|
    CertificationCase.new(certification_id: event[:payload][:certification_id])
  end
end

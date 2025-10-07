# frozen_string_literal: true

class CertificationCase < Strata::Case
  # Don't add an ActiveRecord association since Certification
  # is a separate aggregate root and we don't want to add
  # dependencies between the aggregates at the database layer
  attr_accessor :certification
end

class ExemptionApplicationFormPolicy < ApplicationPolicy
  include Flex::ApplicationFormPolicy

  alias_method :documents?, :edit?
  alias_method :upload_documents?, :edit?
end

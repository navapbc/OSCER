# frozen_string_literal: true

Rails.application.config.to_prepare do
  ActiveModel::Type.register(:array, ArrayType)
  ActiveModel::Type.register(:enum, EnumType)
end

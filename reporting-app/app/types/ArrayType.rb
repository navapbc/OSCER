# frozen_string_literal: true

class ArrayType < ActiveModel::Type::Value
  def type = :array
end

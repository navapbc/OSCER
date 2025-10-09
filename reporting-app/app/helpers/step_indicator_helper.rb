# frozen_string_literal: true

module StepIndicatorHelper
  EXEMPTION_STEPS = [
    { key: :start, label: "Before you start" },
    { key: :exemption_type, label: "Exemption type" },
    { key: :documents, label: "Supporting documents" },
    { key: :review, label: "Review and submit" }
  ].freeze

  def exemption_step_indicator(current_step_key, options = {})
    steps = EXEMPTION_STEPS.map { |s| s[:label] }
    current_index = EXEMPTION_STEPS.index { |s| s[:key] == current_step_key }
    current_step = current_index ? current_index + 1 : 1

    render "application/step_indicator",
           steps: steps,
           current_step: current_step,
           options: options
  end

  def current_exemption_step(action_name)
    case action_name.to_sym
    when :start
      :start
    when :new, :create
      :exemption_type
    when :documents, :upload_documents
      :documents
    when :review, :submit
      :review
    else
      :start
    end
  end
end

# frozen_string_literal: true

module StepIndicatorHelper
  # Define exemption workflow steps in order
  EXEMPTION_STEPS = %i[start exemption_type documents review].freeze

  # Renders the step indicator for the exemption workflow using Strata SDK component
  # @param current_step_key [Symbol] The current step (e.g., :start, :exemption_type, :documents)
  # @param options [Hash] Optional settings (e.g., type: :counters)
  # @return [String] Rendered HTML for the step indicator
  def exemption_step_indicator(current_step_key, options = {})
    render "strata/shared/step_indicator",
           steps: EXEMPTION_STEPS,
           current_step: current_step_key,
           translation_scope: "exemption_application_forms.steps",
           **options
  end

  # Maps controller action names to their corresponding step
  # @param action_name [String, Symbol] The controller action name
  # @return [Symbol] The corresponding step key
  def current_exemption_step(action_name)
    case action_name.to_sym
    when :new
      :start  # "Before you start" page
    when :create
      :exemption_type
    when :documents, :upload_documents
      :documents
    when :review, :submit
      :review
    else
      :start  # Default to first step
    end
  end
end

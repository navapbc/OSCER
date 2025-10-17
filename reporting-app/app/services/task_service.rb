# frozen_string_literal: true

module TaskService
  def self.request_more_information(task, params, information_request_class:, application_form_class:)
    ActiveRecord::Base.transaction do
      application_form = application_form_class.find_by(certification_case_id: task.case_id)
      information_request = information_request_class.new(params)
      information_request.application_form_id = application_form.id
      information_request.application_form_type = application_form_class.name
      information_request.save!
      task.on_hold!
    end

    { success: true }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, information_request_record: e.record }
  end
end

# frozen_string_literal: true

class Demo::CertificationsController < ApplicationController
  layout "demo"

  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def new
    certification_type = params.fetch(:certification_type, nil)
    certification_requirement_params = certification_service.certification_type_requirement_params(certification_type) || {}
    @form = Demo::Certifications::CreateForm.new({ certification_type: certification_type }.merge(certification_requirement_params))
  end

  def create
    @form = Demo::Certifications::CreateForm.new(form_params)

    if @form.invalid?
      flash.now[:errors] = @form.errors.full_messages
      return render :new, status: :unprocessable_entity
    end

    certification_requirements = certification_service.calculate_certification_requirements(@form.attributes.with_indifferent_access)
    member_data = {
      "full_name": @form.member_full_name
    }

    case @form.ex_parte_scenario
    when "Partially met work hours requirement"
      member_data.merge!(FactoryBot.build(:certification_member_data, :partially_met_work_hours_requirement, cert_date: @form.certification_date))
    when "Fully met work hours requirement"
      member_data.merge!(FactoryBot.build(:certification_member_data, :fully_met_work_hours_requirement, cert_date: @form.certification_date, num_months: @form.number_of_months_to_certify))
    else
      # nothing
    end

    @certification = FactoryBot.build(
      :certification,
      :with_member_data_base,
      :connected_to_email,
      member_data_base: member_data,
      email: @form.member_email,
      case_number: @form.case_number,
      certification_requirements: certification_requirements,
    )

    if certification_service.save_new(@certification, current_user)
      redirect_to certification_path(@certification)
    else
      flash.now[:errors] = @certification.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    def certification_service
      CertificationService.new
    end

    def form_params
      params.require(:demo_certifications_create_form)
            .permit(
              :member_email, :case_number, :certification_type, :certification_date, :lookback_period,
              :number_of_months_to_certify, :due_period_days, :ex_parte_scenario, :member_full_name
            )
    end
end

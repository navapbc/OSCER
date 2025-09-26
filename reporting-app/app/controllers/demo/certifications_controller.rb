class Demo::CertificationsController < ApplicationController
  layout "demo"

  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def new
    @form = Demo::Certifications::CreateForm.new
  end

  def create
    form_params = params.require(:demo_certifications_create_form).permit(:beneficiary_email, :case_number, :certification_date, :lookback_period, :number_of_months_to_certify, :due_period_days, :ex_parte_scenario)
    @form = Demo::Certifications::CreateForm.new(form_params)

    if @form.invalid?
      flash.now[:errors] = @form.errors.full_messages
      return render :new, status: :unprocessable_entity
    end

    certification_requirements = certification_service.calculate_certification_requirements(@form)
    beneficiary_data = {}

    case @form.ex_parte_scenario
    when "Partially met work hours requirement"
      beneficiary_data.merge!(FactoryBot.build(:certification_beneficiary_data, :partially_met_work_hours_requirement, cert_date: @form.certification_date))
    when "Fully met work hours requirement"
      beneficiary_data.merge!(FactoryBot.build(:certification_beneficiary_data, :fully_met_work_hours_requirement, cert_date: @form.certification_date, num_months: @form.number_of_months_to_certify))
    else
      # nothing
    end

    @certification = FactoryBot.build(
      :certification,
      :with_beneficiary_data_base,
      :connected_to_email,
      beneficiary_data_base: beneficiary_data,
      email: @form.beneficiary_email,
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
end

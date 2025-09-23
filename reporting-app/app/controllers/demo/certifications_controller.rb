class Demo::CertificationsController < ApplicationController
  layout "demo"

  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def new
    @form = Demo::Certifications::CreateForm.new
  end

  def create
    form_params = params.require(:demo_certifications_create_form).permit(:beneficiary_email, :case_number, :certification_type, :certification_date, :number_of_months_to_certify, :due_period_days, :ex_parte_scenario)
    @form = Demo::Certifications::CreateForm.new(form_params)

    if @form.invalid?
      flash.now[:errors] = @form.errors.full_messages
      return render :new, status: :unprocessable_entity
    end

    certification_requirements = {
      "certification_date": @form.certification_date,
      "months_to_certify": @form.number_of_months_to_certify.times.map { |i| @form.certification_date.beginning_of_month << i },
      "due_date": @form.certification_date + @form.due_period_days.days
    }

    beneficiary_data = {
      "account_email": @form.beneficiary_email,
      "contact": {
        "email": @form.beneficiary_email
      }
    }

    certification_params = {
      beneficiary_id: "123",
      case_number: @form.case_number,
      certification_requirements: certification_requirements,
      beneficiary_data: beneficiary_data
    }

    @certification = Certification.new(certification_params)

    if certification_service.save_new(@certification, current_user)
      # TODO: redirect to cert page? or staff dashboard?
      # render :show, status: :created, location: @certification
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

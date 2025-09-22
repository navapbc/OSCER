class Demo::CertificationsController < ApplicationController
  layout "demo"

  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def new
  end

  def create
    @certification = Certification.new(certification_params)

    if certification_service.save_new(@certification, current_user)
      render :show, status: :created, location: @certification
    else
      render json: @certification.errors, status: :unprocessable_entity
    end
  end

  private
    def certification_service
      Services::CertificationService.new
    end
end

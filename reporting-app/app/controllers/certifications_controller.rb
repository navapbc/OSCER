# frozen_string_literal: true

class CertificationsController < StaffController
  before_action :set_certification, only: %i[ show update ]
  before_action :set_activity_report_application_forms, only: %i[ show create update ]

  # for API endpoints
  skip_before_action :authenticate_user!, only: %i[ create show]

  # GET /certifications
  # GET /certifications.json
  def index
    @certifications = policy_scope(Certification.all)
  end

  # @summary Retrieve a Certification record
  # @tags certifications
  #
  # @response A Certification(200) [Reference:#/components/schemas/CertificationResponseBody]
  def show
  end

  # GET /certifications/new
  def new
    @certification_form = authorize Certification.new
  end

  # @summary Create a Certification record
  # @tags certifications
  #
  # @request_body The Certification data. [Reference:#/components/schemas/CertificationCreateRequestBody]
  # @response Created Certification.(201) [Reference:#/components/schemas/CertificationResponseBody]
  # @response User error.(400) [Reference:#/components/schemas/ErrorResponseBody]
  def create
    @certification = Certification.new(certification_params)

    authorize @certification

    if certification_service.save_new(@certification)
      render :show, status: :created, location: @certification
    else
      render json: @certification.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /certifications/1
  # PATCH/PUT /certifications/1.json
  def update
    if @certification.update(certification_params)
      render :show, status: :ok, location: @certification
    else
      render json: @certification.errors, status: :unprocessable_entity
    end
  end

  private
    def set_certification
      @certification = authorize Certification.find(params[:id])
    end

    def set_activity_report_application_forms
      @activity_report_application_forms = ActivityReportApplicationForm.where(certification_id: @certification&.id)
    end

    def certification_service
      CertificationService.new
    end

    # Only allow a list of trusted parameters through.
    def certification_params
      # support both top-level params and under a "certification" key (for HTML form)
      if params&.has_key?(:certification)
        cert_params = params.fetch(:certification)
      else
        cert_params = params
      end

      cert_params.permit(
        :member_id,
        :case_number,
        :certification_requirements,
        :member_data,
        certification_requirements: {},
        member_data: {}
      ).tap do |cert_params|
        begin
          # handle HTML form input of the JSON blob as a string
          if cert_params[:certification_requirements].present? && cert_params[:certification_requirements].is_a?(String)
            cert_params[:certification_requirements] = JSON.parse(cert_params[:certification_requirements])
          end

          # handle HTML form input of the JSON blob as a string
          if cert_params[:member_data].present? && cert_params[:member_data].is_a?(String)
            cert_params[:member_data] = JSON.parse(cert_params[:member_data])
          end
        rescue JSON::ParserError => e
          raise ActionController::BadRequest.new(e.message)
        end
      end
    end
end

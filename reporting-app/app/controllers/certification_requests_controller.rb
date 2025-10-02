class CertificationRequestsController < StaffController
  before_action :set_certification_request, only: %i[ show update ]

  # GET /certifications
  # GET /certifications.json
  def index
    @certification_requests = policy_scope(CertificationRequest.all)
  end

  # GET /certifications/1
  # GET /certifications/1.json
  def show
  end

  # GET /certifications/new
  def new
    @certification_request_form = authorize CertificationRequest.new
  end

  # POST /certifications
  # POST /certifications.json
  def create
    @certification_request = CertificationRequest.new(certification_request_params)

    authorize @certification_request

    if certification_service.save_new(@certification_request)
      render :show, status: :created, location: @certification_request
    else
      render json: @certification_request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /certifications/1
  # PATCH/PUT /certifications/1.json
  def update
    if @certification_request.update(certification_request_params)
      render :show, status: :ok, location: @certification_request
    else
      render json: @certification_request.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certification_request
      @certification_request = authorize CertificationRequest.find(params[:id])
    end

    def certification_service
      CertificationRequestService.new
    end

    # Only allow a list of trusted parameters through.
    def certification_request_params
      # support both top-level params and under a "certification" key (for HTML form)
      if params&.has_key?(:certification_request)
        cert_request_params = params.fetch(:certification_request)
      else
        cert_request_params = params
      end

      cert_request_params.permit(
        :beneficiary_id,
        :case_number,
        :certification_requirements,
        :beneficiary_data,
        certification_requirements: {},
        beneficiary_data: {}
      ).tap do |cert_request_params|
        begin
          # handle HTML form input of the JSON blob as a string
          if cert_request_params[:certification_requirements].present? && cert_request_params[:certification_requirements].is_a?(String)
            cert_request_params[:certification_requirements] = JSON.parse(cert_request_params[:certification_requirements])
          end

          # handle HTML form input of the JSON blob as a string
          if cert_request_params[:beneficiary_data].present? && cert_request_params[:beneficiary_data].is_a?(String)
            cert_request_params[:beneficiary_data] = JSON.parse(cert_request_params[:beneficiary_data])
          end
        rescue JSON::ParserError => e
          raise ActionController::BadRequest.new(e.message)
        end
      end
    end
end

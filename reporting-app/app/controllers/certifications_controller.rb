class CertificationsController < StaffController
  before_action :set_certification, only: %i[ show update destroy ]

  # GET /certifications
  # GET /certifications.json
  def index
    @certifications = Certification.all
  end

  # GET /certifications/1
  # GET /certifications/1.json
  def show
  end

  # GET /certifications/new
  def new
    @certification_form = Certification.new
  end

  # POST /certifications
  # POST /certifications.json
  def create
    @certification = Certification.new(certification_params)

    if @certification.save
      # TODO: could be moved to an event processing step or something
      is_exempt = false
      if not is_exempt
        # TODO: for demo purposes, create an activity report associated with the
        # current user for this Certification
        bene_user = current_user
        ActivityReportApplicationForm.create!(user_id: bene_user.id, certification_id: @certification.id)
      end

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

  # # DELETE /certifications/1
  # # DELETE /certifications/1.json
  # def destroy
  #   @certification.destroy!
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certification
      @certification = Certification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def certification_params
      params.require(:certification).permit(:beneficiary_id, :case_number, :certification_requirements, :beneficiary_data).tap do |params|
        if params[:certification_requirements].present?
            params[:certification_requirements] = JSON.parse(params[:certification_requirements])
        end

        if params[:beneficiary_data].present?
            params[:beneficiary_data] = JSON.parse(params[:beneficiary_data])
        end
      end
    end
end

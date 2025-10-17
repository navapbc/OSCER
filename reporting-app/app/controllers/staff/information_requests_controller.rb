# frozen_string_literal: true

module Staff
  class InformationRequestsController < StaffController
    def show
      @information_request = InformationRequest.find(params[:id])
    end
  end
end

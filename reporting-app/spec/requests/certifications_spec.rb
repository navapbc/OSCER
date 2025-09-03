require 'rails_helper'

RSpec.describe "/certifications", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Certification. As you add validations to Certification, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # CertificationsController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  # describe "GET /index" do
  #   it "renders a successful response" do
  #     Certification.create! valid_attributes
  #     get certifications_url, headers: valid_headers, as: :json
  #     expect(response).to be_successful
  #   end
  # end

  # describe "GET /show" do
  #   it "renders a successful response" do
  #     certification = Certification.create! valid_attributes
  #     get certification_url(certification), as: :json
  #     expect(response).to be_successful
  #   end
  # end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Certification" do
        expect {
          post certifications_url,
               params: { certification: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Certification, :count).by(1)
      end

      it "renders a JSON response with the new certification" do
        post certifications_url,
             params: { certification: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Certification" do
        expect {
          post certifications_url,
               params: { certification: invalid_attributes }, as: :json
        }.not_to change(Certification, :count)
      end

      it "renders a JSON response with errors for the new certification" do
        post certifications_url,
             params: { certification: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  # describe "PATCH /update" do
  #   context "with valid parameters" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested certification" do
  #       certification = Certification.create! valid_attributes
  #       patch certification_url(certification),
  #             params: { certification: new_attributes }, headers: valid_headers, as: :json
  #       certification.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "renders a JSON response with the certification" do
  #       certification = Certification.create! valid_attributes
  #       patch certification_url(certification),
  #             params: { certification: new_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:ok)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "renders a JSON response with errors for the certification" do
  #       certification = Certification.create! valid_attributes
  #       patch certification_url(certification),
  #             params: { certification: invalid_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end
  # end

  # describe "DELETE /destroy" do
  #   it "destroys the requested certification" do
  #     certification = Certification.create! valid_attributes
  #     expect {
  #       delete certification_url(certification), headers: valid_headers, as: :json
  #     }.to change(Certification, :count).by(-1)
  #   end
  # end
end

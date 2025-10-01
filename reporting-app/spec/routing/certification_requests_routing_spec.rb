require "rails_helper"

RSpec.describe CertificationRequestsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/staff/certification_requests").to route_to("certification_requests#index")
    end

    it "routes to #show" do
      expect(get: "/staff/certification_requests/1").to route_to("certification_requests#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/staff/certification_requests").to route_to("certification_requests#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/staff/certification_requests/1").to route_to("certification_requests#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/staff/certification_requests/1").to route_to("certification_requests#update", id: "1")
    end
  end

  describe "API routing" do
    it "routes to #show" do
      expect(get: "/api/certification_requests/1").to route_to("certification_requests#show", id: "1", format: :json)
    end

    it "routes to #create" do
      expect(post: "/api/certification_requests").to route_to("certification_requests#create", format: :json)
    end
  end
end

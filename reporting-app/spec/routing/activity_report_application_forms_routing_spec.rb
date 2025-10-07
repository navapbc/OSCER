# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActivityReportApplicationFormsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/certifications/1/activity_report_application_forms/new").to route_to("activity_report_application_forms#new", certification_id: "1")
    end

    it "routes to #show" do
      expect(get: "/certifications/1/activity_report_application_forms/1").to route_to("activity_report_application_forms#show", certification_id: "1", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/certifications/1/activity_report_application_forms/1/edit").to route_to("activity_report_application_forms#edit", certification_id: "1", id: "1")
    end


    it "routes to #create" do
      expect(post: "/certifications/1/activity_report_application_forms").to route_to("activity_report_application_forms#create", certification_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/certifications/1/activity_report_application_forms/1").to route_to("activity_report_application_forms#update", certification_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/certifications/1/activity_report_application_forms/1").to route_to("activity_report_application_forms#update", certification_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/certifications/1/activity_report_application_forms/1").to route_to("activity_report_application_forms#destroy", certification_id: "1", id: "1")
    end
  end
end

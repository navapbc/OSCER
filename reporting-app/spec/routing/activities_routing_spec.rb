# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActivitiesController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/certifications/1/activity_report_application_forms/1/activities/new").to route_to("activities#new", certification_id: "1", activity_report_application_form_id: "1")
    end

    it "routes to #show" do
      expect(get: "/certifications/1/activity_report_application_forms/1/activities/1").to route_to("activities#show", certification_id: "1", activity_report_application_form_id: "1", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/certifications/1/activity_report_application_forms/1/activities/1/edit").to route_to("activities#edit", certification_id: "1", activity_report_application_form_id: "1", id: "1")
    end


    it "routes to #create" do
      expect(post: "/certifications/1/activity_report_application_forms/1/activities").to route_to("activities#create", certification_id: "1", activity_report_application_form_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/certifications/1/activity_report_application_forms/1/activities/1").to route_to("activities#update", certification_id: "1", activity_report_application_form_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/certifications/1/activity_report_application_forms/1/activities/1").to route_to("activities#update", certification_id: "1", activity_report_application_form_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/certifications/1/activity_report_application_forms/1/activities/1").to route_to("activities#destroy", certification_id: "1", activity_report_application_form_id: "1", id: "1")
    end
  end
end

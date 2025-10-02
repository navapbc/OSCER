require 'rails_helper'

RSpec.describe "dashboard/index", type: :view do
  let(:certification_request) { create(:certification_request) }

  before do
    assign(:all_certifications, [
      certification_request
    ])
    assign(:certification_request, certification_request)
  end

  context 'with no current exemption or activity report' do
    it 'renders views to start an activity report or start an exemption request' do
      render
      expect(rendered).to have_selector('h2', text: I18n.t('dashboard.new_certification_request.activity_report.title'))
      expect(rendered).to have_selector('h2', text: I18n.t('dashboard.new_certification_request.exemption_request.title'))
    end

    it 'renders buttons to start a new activity report or exemption request' do
      render
      expect(rendered).to have_selector('a', text: I18n.t('dashboard.new_certification_request.activity_report.report_activities_button'))
      expect(rendered).to have_selector('a', text: I18n.t('dashboard.new_certification_request.exemption_request.request_exemption_button'))
    end
  end

  context "with an in-progress activity report" do
    before do
      assign(:activity_report_application_form, create(:activity_report_application_form, certification_request: certification_request))
    end

    it 'renders a message to continue the activity report' do
      render
      expect(rendered).to have_selector('strong', text: I18n.t('dashboard.new_certification_request.activity_report.in_progress_status'))
    end

    it 'renders a button to continue the activity report' do
      render
      expect(rendered).to have_selector('a', text: I18n.t('dashboard.new_certification_request.activity_report.continue_report_button'))
    end
  end

  context "with an in-progress exemption request" do
    before do
      assign(:exemption_application_form, create(:exemption_application_form, certification_request_id: certification_request.id))
    end

    it 'renders a message to continue the exemption request' do
      render
      expect(rendered).to have_selector('strong', text: I18n.t('dashboard.new_certification_request.exemption_request.in_progress_status'))
    end

    it 'renders a button to continue the exemption request' do
      render
      expect(rendered).to have_selector('a', text: I18n.t('dashboard.new_certification_request.exemption_request.continue_request_button'))
    end
  end

  context "with a submitted activity report" do
    let (:activity_report_application_form) { create(:activity_report_application_form, :with_submitted_status, certification_request: certification_request) }
    let (:activity_report_case) { create(:activity_report_case, application_form_id: activity_report_application_form.id) }

    before do
      assign(:activity_report_application_form, activity_report_application_form)
      assign(:activity_report_case, activity_report_case)
    end

    it 'renders a message that the activity report is under review' do
      render
      expect(rendered).to have_selector('p', text: I18n.t('dashboard.activity_report_submitted.intro'))
    end

    it 'has a button to view the submitted activity report' do
      render
      expect(rendered).to have_selector('a', text: I18n.t('dashboard.activity_report_submitted.view_activity_report_button'))
    end
  end

  context "with a submitted exemption request" do
    let (:exemption_application_form) { create(:exemption_application_form, :with_submitted_status, certification_request_id: certification_request.id) }
    let (:exemption_case) { create(:exemption_case, application_form_id: exemption_application_form.id) }

    before do
      assign(:exemption_application_form, exemption_application_form)
      assign(:exemption_case, exemption_case)
    end

    it 'renders a message that the exemption request is under review' do
      render
      expect(rendered).to have_selector('p', text: I18n.t('dashboard.exemption_submitted.intro'))
    end

    it 'has a button to view the submitted exemption request' do
      render
      expect(rendered).to have_selector('a', text: I18n.t('dashboard.exemption_submitted.view_exemption_button'))
    end
  end

  context "with an approved activity report" do
    let (:activity_report_application_form) { create(:activity_report_application_form, :with_submitted_status, certification_request: certification_request) }
    let (:activity_report_case) { create(:activity_report_case, application_form_id: activity_report_application_form.id, activity_report_approval_status: "approved") }

    before do
      assign(:activity_report_application_form, activity_report_application_form)
      assign(:activity_report_case, activity_report_case)
    end

    it 'renders a message that the activity report is approved' do
      render
      expect(rendered).to have_selector('p', text: I18n.t('dashboard.activity_report_approved.intro'))
    end

    it 'has a button to view the certification_request' do
      render
      expect(rendered).to have_selector('a', text: I18n.t('dashboard.activity_report_approved.view_completed_certification_request_button'))
    end
  end

  context "with an approved exemption request" do
    let (:exemption_application_form) { create(:exemption_application_form, :with_submitted_status, certification_request_id: certification_request.id) }
    let (:exemption_case) { create(:exemption_case, application_form_id: exemption_application_form.id, exemption_request_approval_status: "approved") }

    before do
      assign(:exemption_application_form, exemption_application_form)
      assign(:exemption_case, exemption_case)
    end

    it 'renders a message that the exemption request is approved' do
      render
      expect(rendered).to have_selector('p', text: I18n.t('dashboard.exemption_approved.intro'))
    end

    it 'has a button to view the certification_request' do
      render
      expect(rendered).to have_selector('a', text: I18n.t('dashboard.exemption_approved.view_certification_request_button'))
    end
  end

  context "with previous certification_requests" do
    let(:older_certification_request) { create(:certification_request) }

    before do
      assign(:all_certifications, [
        certification_request,
        older_certification_request
      ])
    end

    it 'renders a section for previous certification_requests' do
      render
      expect(rendered).to have_selector('h2', text: I18n.t('dashboard.index.previous_certification_requests.title'))
    end

    it 'renders a button to review previous certification_requests' do
      render
      expect(rendered).to have_selector('a', text: I18n.t('dashboard.index.previous_certification_requests.review_previous_certification_requests_button'))
    end
  end

  context "without previous certification_requests" do
    it 'does not render a section for previous certification_requests' do
      render
      expect(rendered).not_to have_selector('h2', text: I18n.t('dashboard.index.previous_certification_requests.title'))
    end

    it 'does not render a button to review previous certification_requests' do
      render
      expect(rendered).not_to have_selector('a', text: I18n.t('dashboard.index.previous_certification_requests.review_previous_certification_requests_button'))
    end
  end
end

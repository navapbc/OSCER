require 'rails_helper'

RSpec.describe ActivityReportApplicationForm::ActivityPolicy, type: :policy do
  subject { described_class.new(current_user, record) }

  let(:owning_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:activity_report_application_form) { create(:activity_report_application_form, :with_activities, user_id: owning_user.id) }
  let(:activity) { activity_report_application_form.activities.first }
  let(:base_record) { [activity_report_application_form, activity] }

  let(:record) { base_record }

  context "when unauthenticated" do
    let(:current_user) { nil }

    it { is_expected_in_block.to raise_error(Pundit::NotAuthorizedError) }
  end

  context "when owning user" do
    let(:current_user) { owning_user }

    it { is_expected.to permit_all_actions }
  end

  context "when owning user, on submitted form" do
    let(:current_user) { owning_user }
    let(:record) do
      activity_report_application_form.submit_application
      base_record
    end

    it { is_expected.to forbid_only_actions(:destroy, :create, :new, :update, :edit, :update) }
  end

  context "when not owning user" do
    let(:current_user) { other_user }

    it { is_expected.to forbid_all_actions }
  end

  context "when not owning user, with their own form" do
    let(:current_user) { other_user }
    let(:other_form) { create(:activity_report_application_form, user_id: other_user.id) }
    let(:other_activity) { create(:activity, activity_report_application_form: other_form) }
  end
end

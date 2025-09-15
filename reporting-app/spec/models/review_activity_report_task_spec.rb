require 'rails_helper'

RSpec.describe ReviewActivityReportTask, type: :model do
  let(:application_form) { create(:activity_report_application_form) }
  let(:kase) { create(:activity_report_case, application_form_id: application_form.id) }

  describe "inheritance" do
    it "inherits from Flex::Task" do
      expect(described_class.superclass).to eq(Flex::Task)
    end
  end

  describe "#approve" do
    let(:task) { create(:review_activity_report_task, case: kase) }

    it "sets the status to approved" do
      task.approve
      expect(task.status).to eq("approved")
    end

    it "saves the task" do
      expect { task.approve }.to change { task.reload.status }.from("pending").to("approved")
    end

    it "persists the status change to the database" do
      task.approve
      task.reload
      expect(task.status).to eq("approved")
    end

    it "works when task is already completed" do
      task.send(:status=, :completed)
      task.save!
      task.approve
      expect(task.status).to eq("approved")
    end

    it "works when task is already denied" do
      task.send(:status=, :denied)
      task.save!
      task.approve
      expect(task.status).to eq("approved")
    end
  end

  describe "#deny" do
    let(:task) { create(:review_activity_report_task, case: kase) }

    it "sets the status to denied" do
      task.deny
      expect(task.status).to eq("denied")
    end

    it "saves the task" do
      expect { task.deny }.to change { task.reload.status }.from("pending").to("denied")
    end

    it "persists the status change to the database" do
      task.deny
      task.reload
      expect(task.status).to eq("denied")
    end

    it "works when task is already completed" do
      task.send(:status=, :completed)
      task.save!
      task.deny
      expect(task.status).to eq("denied")
    end

    it "works when task is already approved" do
      task.send(:status=, :approved)
      task.save!
      task.deny
      expect(task.status).to eq("denied")
    end
  end

  describe "status enum" do
    let(:task) { create(:review_activity_report_task, case: kase) }

    it "includes all expected statuses" do
      expect(described_class.statuses.keys).to contain_exactly("pending", "completed", "approved", "denied")
    end

    it "has correct integer values for statuses" do
      expect(described_class.statuses).to eq({
        "pending" => 0,
        "completed" => 1,
        "approved" => 2,
        "denied" => 3
      })
    end

    it "allows setting status to approved" do
      task.approve
      expect(task.approved?).to be true
    end

    it "allows setting status to denied" do
      task.deny
      expect(task.denied?).to be true
    end
  end
end

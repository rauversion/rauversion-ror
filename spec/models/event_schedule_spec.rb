require "rails_helper"

RSpec.describe EventSchedule, type: :model do
  describe "validations" do
    let(:user) { FactoryBot.create(:user) }
    let(:event) { FactoryBot.create(:event, user: user) }

    it { should belong_to(:event) }

    it "validates that start_date is before end_date" do
      schedule = FactoryBot.build(:event_schedule, event: event, start_date: 1.day.from_now, end_date: 1.day.ago)
      expect(schedule).not_to be_valid
      expect(schedule.errors[:start_date]).to include("must be before end date")
    end

    it "is valid when start_date is before end_date" do
      schedule = FactoryBot.build(:event_schedule, event: event, start_date: 1.day.ago, end_date: 1.day.from_now)
      expect(schedule).to be_valid
    end
  end
end

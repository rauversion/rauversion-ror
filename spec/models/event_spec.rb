require "rails_helper"

RSpec.describe Event, type: :model do
  let!(:user) {
    FactoryBot.create(:user, username: "user", role: "user")
  }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:event_hosts) }
    it { should have_many(:event_schedules) }
    it { should have_many(:event_recordings) }
    # it { should have_many(:schedule_schedulings).through(:event_schedules) }
    it { should have_many(:event_tickets) }
    it { should have_many(:purchases) }
    it { should have_many(:purchased_items) }
    it { should have_many(:paid_purchased_items) }
    it { should have_many(:purchased_event_tickets) }
    it { should have_one_attached(:cover) }
  end

  describe "scopes" do
    before do
      @event1 = FactoryBot.create(:event, state: "published", user: user, event_start: 1.day.from_now)
      @event2 = FactoryBot.create(:event, state: "draft", user: user, event_start: 2.days.from_now)
      @event3 = FactoryBot.create(:event, state: "published", user: user, event_start: 3.days.from_now)
      @event4 = FactoryBot.create(:event, state: "published", user: user, event_start: 3.days.ago)
    end

    describe ".upcoming" do
      it "returns events in ascending order of start date" do
        expect(Event.upcoming_events).to eq([@event1, @event3])
      end
    end

    describe ".published" do
      it "returns published events" do
        expect(Event.upcoming_events.map(&:id)).to eq([@event1.id, @event3.id])
      end
    end

    describe ".past_events" do
      it "returns past_events events" do
        expect(Event.past_events).to eq([@event4])
      end
    end

    describe "creating tickets" do
      let(:event) { FactoryBot.create(:event, user: user) }

      it "can create associated tickets" do
        ticket = FactoryBot.create(:event_ticket, event: event, selling_start: 1.day.from_now, selling_end: 3.day.from_now)
        expect(event.event_tickets).to include(ticket)

        expect(event.available_tickets(2.day.from_now)).to be_any
        expect(event.available_tickets(Time.now)).to be_empty
      end
    end
  end
end

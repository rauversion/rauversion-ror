require 'rails_helper'

RSpec.describe EventTicket, type: :model do
  it { should belong_to(:event) }
  it { should have_many(:purchased_items) }
  xit { should have_many(:purchased_tickets) }
  xit { should have_many(:paid_tickets) }

  describe 'validations' do
    let(:user){ FactoryBot.create(:user) }
    let(:event){ FactoryBot.create(:event, user: user) }

    it 'validates that selling_start is before selling_end' do
      ticket = FactoryBot.build(:event_ticket, event: event, selling_start: 1.day.from_now, selling_end: 1.day.ago)
      expect(ticket).not_to be_valid
      expect(ticket.errors[:selling_start]).to include("must be before selling end")
    end

    it 'is valid when selling_start is before selling_end' do
      ticket = FactoryBot.build(:event_ticket, event: event, selling_start: 1.day.ago, selling_end: 1.day.from_now)
      expect(ticket).to be_valid
    end
  end

  describe '#free?' do
    let(:free_ticket) { FactoryBot.build(:event_ticket, price: 0) }
    let(:paid_ticket) { FactoryBot.build(:event_ticket, price: 50) }

    it 'returns true if the price is zero' do
      expect(free_ticket.free?).to be true
    end

    it 'returns false if the price is not zero' do
      expect(paid_ticket.free?).to be false
    end
  end
end

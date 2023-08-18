require 'rails_helper'

RSpec.describe Purchase, type: :model do
  it { belong_to(:user) }
  it { have_many(:purchased_items) }
  it { belong_to(:purchasable) }


  describe 'purchasing tickets' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:event) { FactoryBot.create(:event, user: user) }

    it 'validates qty of tickets' do
      ticket = FactoryBot.create(:event_ticket, event: event, qty: 5, min_tickets_per_order: 2 )
      purchase = user.purchases.new(purchasable: event)
      purchase.virtual_purchased = event.event_tickets.map do |aa|
        VirtualPurchasedItem.new({resource: aa, quantity: 6})
      end
      expect(purchase).to_not be_valid
      expect(purchase.errors.full_messages.join(" ")).to include("Exceeded available quantity")

      purchase.store_items
      purchase.save
      
      expect(purchase).to_not be_persisted
    end

    it 'validates min_tickets_per_order of tickets' do
      ticket = FactoryBot.create(:event_ticket, event: event, qty: 100, min_tickets_per_order: 2 )
      purchase = user.purchases.new(purchasable: event)
      purchase.virtual_purchased = event.event_tickets.map do |aa|
        VirtualPurchasedItem.new({resource: aa, quantity: 6})
      end
      expect(purchase).to_not be_valid
      expect(purchase.errors.full_messages.join(" ")).to include("Insufficient quantity ")

      purchase.store_items
      purchase.save
      
      expect(purchase).to_not be_persisted
    end

    it 'validates max_tickets_per_order of tickets' do
      ticket = FactoryBot.create(:event_ticket, event: event, qty: 100, max_tickets_per_order: 2 )
      purchase = user.purchases.new(purchasable: event)
      purchase.virtual_purchased = event.event_tickets.map do |aa|
        VirtualPurchasedItem.new({resource: aa, quantity: 6})
      end
      expect(purchase).to_not be_valid
      expect(purchase.errors.full_messages.join(" ")).to include("Insufficient quantity ")

      purchase.store_items
      purchase.save

      expect(purchase).to_not be_persisted
      # expect(purchase.purchased_items.size).to eq(3)
    end
  end
end

require 'rails_helper'

RSpec.describe EventTicket, type: :model do
  it { should belong_to(:event) }
  it { should have_many(:purchased_items) }
  xit { should have_many(:purchased_tickets) }
  xit { should have_many(:paid_tickets) }

end

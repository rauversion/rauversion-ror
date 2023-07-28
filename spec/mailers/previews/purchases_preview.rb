# Preview all emails at http://localhost:3000/rails/mailers/purchases
class PurchasesPreview < ActionMailer::Preview
  def event_ticket_confirmation
    PurchasesMailer.with(purchase: Purchase.last).event_ticket_confirmation
  end
end

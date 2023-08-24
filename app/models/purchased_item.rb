class PurchasedItem < ApplicationRecord
  belongs_to :purchase
  belongs_to :purchased_item, polymorphic: true

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :paid

    event :confirm do
      transitions from: :pending, to: :paid
    end
  end

  def qr
    url = Rails.application.routes.url_helpers.event_event_ticket_url(purchase.purchasable, signed_id)
    encoded_url = ERB::Util.url_encode(url)
    size = 120
    data_param = "chl=#{encoded_url}"
    google_charts_url = "https://chart.googleapis.com/chart?cht=qr&chs=#{size}x#{size}&#{data_param}"
  end

  def toggle_check_in!
    if checked_in?
      update({checked_in: false, checked_in_at: nil})
    else
      update({checked_in: true, checked_in_at: Time.zone.now})
    end
  end
end

class PurchasedItem < ApplicationRecord
  belongs_to :purchase
  belongs_to :purchased_item, polymorphic: true


  def encoded_id
    purchase.verifier.generate(self.id)
  end

  def decoded_id
    purchase.verifier.verified(self.id)
  end
end

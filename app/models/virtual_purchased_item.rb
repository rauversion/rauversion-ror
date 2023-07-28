class VirtualPurchasedItem
  include ActiveModel::Model

  attr_accessor :resource, :quantity

  def marked_for_destruction?
    false
  end

  def new_record?
    true
  end
end
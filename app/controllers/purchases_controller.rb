class PurchasesController < ApplicationController

  def index
    @purchases = current_user.purchases.page
  end

  def tickets
    @purchases = current_user.purchases.where(purchasable_type: "Event").page
  end

  def music
    @purchases = current_user.purchases.where(purchasable_type: "Track").page
  end
end

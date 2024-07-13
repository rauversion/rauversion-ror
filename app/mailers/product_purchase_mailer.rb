class ProductPurchaseMailer < ApplicationMailer
  def purchase_confirmation(purchase)
    @purchase = purchase
    @user = purchase.user
    mail(to: @user.email, subject: 'Purchase Confirmation')
  end

  def status_update(purchase)
    @purchase = purchase
    @user = purchase.user
    mail(to: @user.email, subject: "Your order status has been updated")
  end
end
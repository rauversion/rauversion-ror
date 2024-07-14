class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_seller
  before_action :set_purchase, only: [:product_show, :update, :refund]

  def index
    @tab = params[:tab].present? ? params[:tab].singularize.capitalize : "Album"

    if @tab == "Product"
      @collection = ProductPurchase.for_seller(current_user)
                                .order(created_at: :desc)
                                .page(params[:page])
    else
      @collection = current_user.user_sales_for(@tab)                            
    end
  end

  def show
    unless @purchase.product_purchase_items.joins(:product).where(products: { user_id: current_user.seller_account_ids }).exists?
      redirect_to admin_product_purchases_path, alert: 'Access denied.'
    end
  end

  def product_show
    @product_item = ProductPurchase.for_seller(current_user).find_by(id: params[:id])
    @product = @product_item.products.first
    unless @product_item
      redirect_to sales_path, alert: 'Product not found in this purchase.'
    end
  end

  def update
    if @purchase.update(purchase_params)
      if @purchase.saved_change_to_shipping_status? or 
        @purchase.saved_change_to_tracking_code? or
        @purchase.saved_change_to_status? 
        ProductPurchaseMailer.status_update(@purchase).deliver_later 
      end
      # flash[:notice] = 'Purchase was successfully updated.'
      redirect_to sales_path(tab: "Product"), notice: 'Purchase was successfully updated.'
    else
      # render :product_show
      # flash[:notice] = 'no.'
      redirect_to sales_path(tab: "Product"), notice: 'no'
    end
  end

  def refund
    # @product_item = @purchase.product_purchase_items.find(params[:id])
    
    stripe_refund = Stripe::Refund.create({
      payment_intent: @purchase.payment_intent_id,
      # amount: (@product_item.price * 100).to_i # Refund amount in cents
    })

    Rails.logger.info(stripe_refund)
    if stripe_refund.status == 'succeeded'
      @purchase.update(status: :refunded)
      # @product_item.update(refunded: true)
      flash.now[:notice] = 'Product was successfully refunded.'
      # redirect_to product_show_sale_path(@purchase), notice: 'Product was successfully refunded.'
    else
      flash.now[:notice] = 'Refund failed. Please try again.'
      # redirect_to product_show_sale_path(@purchase), alert: 'Refund failed. Please try again.'
    end
  rescue Stripe::StripeError => e
    flash.now[:notice] = "Refund failed: #{e.message}"
    # redirect_to product_show_sale_path(@purchase), alert: "Refund failed: #{e.message}"
  end

  private

  def ensure_seller
    redirect_to root_path, alert: 'Access denied.' unless current_user.can_sell_products?
  end

  def set_purchase
    @purchase = ProductPurchase.for_seller(current_user).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_product_purchases_path, alert: 'Purchase not found.'
  end

  def purchase_params
    params.require(:product_purchase).permit(:shipping_status, :tracking_code)
  end
end

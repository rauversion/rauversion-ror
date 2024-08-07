# app/controllers/product_cart_controller.rb
class ProductCartController < ApplicationController
  include ApplicationHelper # This gives us access to the current_cart method
  before_action :set_cart

  def add
    product = Product.find(params[:product_id])
    @cart.add_product(product)
    redirect_back(fallback_location: root_path, notice: 'Item added to cart')
  end

  def show
    @cart_items = @cart.product_cart_items.includes(:product)
  end

  def remove
    item = @cart.product_cart_items.find_by(product_id: params[:product_id])
    item.destroy if item
    @cart_items = @cart.product_cart_items.includes(:product)
    render "destroy"
    # redirect_to( product_cart_path, notice: 'Item removed from cart')
  end

  private

  def set_cart
    @cart = current_cart
    if @cart.blank?
      redirect_to root_path, notice: "Log in first to access your cart" and return
    end
  end
end
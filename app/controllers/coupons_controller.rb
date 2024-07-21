class CouponsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coupon, only: [:show, :edit, :update, :destroy]

  def index
    @profile = User.find_by(username: params[:id] || params[:user_id])

    @coupons = current_user.coupons
  end

  def show
  end

  def new
    @coupon = current_user.coupons.new
  end

  def create
    @coupon = current_user.coupons.new(coupon_params)

    if @coupon.save
      redirect_to user_coupon_path(current_user.username, @coupon), notice: 'Coupon was successfully created.'
    else
      render :new, status: 422
    end
  end

  def edit
  end

  def update
    if @coupon.update(coupon_params)
      redirect_to user_coupon_path(current_user.username, @coupon), notice: 'Coupon was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @coupon.destroy
    redirect_to user_coupons_path(current_user.username), notice: 'Coupon was successfully destroyed.'
  end

  private

  def set_coupon
    @coupon = current_user.coupons.find(params[:id])
  end

  def coupon_params
    params.require(:coupon).permit(:code, :discount_type, :discount_amount, :expires_at)
  end
end

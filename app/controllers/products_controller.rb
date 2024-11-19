# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: [:edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @profile = User.find_by(username: params[:id] || params[:user_id])

    #@profile = User.find_by(username: params[:username]) || current_user
    @q = @profile.products.active.includes(:user, :album).ransack(params[:q])
    @products = @q.result(distinct: true).order(created_at: :desc)

    #@products = @profile.products.active.includes(:user, :album).order(created_at: :desc)
    @products = @products.by_category(params[:category]) if params[:category].present?
    @products = @products.page(params[:page]).per(20) # Assuming you're using Kaminari for pagination
  end

  def show

    @profile = User.find_by(username: params[:user_id])

    @product = @profile.products.friendly.find(params[:id])

    @product_variants = @product.product_variants

    
    if request.headers["Turbo-Frame"] == "gallery-photo"
      product_image = @product.product_images.find(params[:image])
      render turbo_stream: [
        turbo_stream.update(
          "gallery-photo",
          partial: "gallery_photo",
          locals: { image: product_image.image }
        )
      ] and return
    end
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(product_params)

    if params[:changed_form]
      render "create" and return
    end

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render "create"
      # render :new, status: 422
    end
  end

  def edit
  end

  def update

    @product.assign_attributes(product_params)
    
    if params[:changed_form]
      render "update" and return
    end

    if @product.save
      redirect_to user_product_path(current_user, @product), notice: 'Product was successfully updated.'
    else
      Rails.logger.error("AAA #{@product.errors.full_messages}")
      # render :edit, status: 422
      render "update"
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully deleted.'
  end

  private

  def set_product
    @product = current_user.products.friendly.find(params[:id])
  end

  def authorize_user
    unless @product.user == current_user || current_user.is_admin?
      redirect_to products_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def product_params
    params.require(:product).permit(
      :title, :coupon_id,
      :limited_edition, :limited_edition_count, :include_digital_album, :visibility, 
      :name_your_price, :shipping_days, :shipping_begins_on, :shipping_within_country_price, 
      :shipping_worldwide_price, :quantity, :playlist_id,
      :title, :description, :price, :sku, :category, :status, :stock_quantity,
      :limited_edition, :limited_edition_count, :include_digital_album,
      :visibility, :name_your_price, :shipping_days, :shipping_begins_on,
      :shipping_within_country_price, :shipping_worldwide_price, :quantity,
      :shipping_days,
      images: [], product_variants_attributes: [:id, :name, :price, :stock_quantity, :_destroy],
      product_options_attributes: [:id, :name, :quantity, :sku, :_destroy],
      product_images_attributes: [:id, :name, :description, :image, :_destroy],
      product_shippings_attributes: [:id, :country, :base_cost, :additional_cost, :_destroy]
    )
  end
end
class PurchasesController < ApplicationController
  before_action :authenticate_user!

  def index
    @purchases = current_user.purchases.page
  end

  def tickets
    @purchases = current_user.purchases.where(state: "paid", purchasable_type: "Event").page
  end

  def music
    kind = (params[:tab] == "tracks") ? "Track" : "Playlist"
    type = params[:type] || "paid"
    @collection = current_user.purchases.where(state: type, purchasable_type: kind).page
  end

  def download
    @purchase = Purchase.find(params[:id])
    
    if @purchase.purchasable.zip.attached?
      render turbo_stream: turbo_stream.replace(
        "purchase_#{@purchase.id}_download",
        partial: 'purchases/download_ready',
        locals: { purchase: @purchase }
      )
    else
      ZipperJob.perform_later(purchase_id: @purchase.id)
      render turbo_stream: turbo_stream.replace(
        "purchase_#{@purchase.id}_download",
        partial: 'purchases/download_processing',
        locals: { purchase: @purchase }
      )
    end
  end

  def check_zip_status
    @purchase = Purchase.find(params[:id])
    if @purchase.purchasable.zip.attached?
      render turbo_stream: turbo_stream.replace(
        "purchase_#{@purchase.id}_download",
        partial: 'purchases/download_ready',
        locals: { purchase: @purchase }
      )
    else
      head :no_content
    end
  end
end

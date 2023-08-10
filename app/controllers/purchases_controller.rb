class PurchasesController < ApplicationController

  before_action :authenticate_user!

  def index
    @purchases = current_user.purchases.page
  end

  def tickets
    @purchases = current_user.purchases.where(state: "paid", purchasable_type: "Event").page
  end

  def music
    kind = params[:tab] == "tracks" ? "Track" : "Playlist"
    @collection = current_user.purchases.where(state: "paid", purchasable_type: kind).page
  end
end

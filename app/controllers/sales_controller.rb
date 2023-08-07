class SalesController < ApplicationController

  def index
    @tab = params[:tab] == "tracks" ? "Track" : "Album"
    @collection = current_user.user_sales_for(@tab)
  end
end

class SalesController < ApplicationController
  before_action :authenticate_user!

  def index
    @tab = (params[:tab] == "tracks") ? "Track" : "Album"
    @collection = current_user.user_sales_for(@tab)
  end
end

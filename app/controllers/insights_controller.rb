class InsightsController < ApplicationController
  def show
    @user = User.find_by(username: params[:user_id])
  end
end

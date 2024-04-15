class PhotosController < ApplicationController


  def create
  end

  def update
    current_user.update(resource_params)

    redirect_to "/" + current_user.username + "/about"
  end

  def destroy
  end


  private
  def resource_params
    params.require(:user).permit(photos_attributes: [:image])
  end
end

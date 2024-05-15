class PhotosController < ApplicationController


  def create
  end

  def show
    @photos = User.find(params[:user_id]).photos
    @photo = User.find(params[:user_id]).photos.find(params[:id])
    @prev_photo = @photos.where("id < ?", @photo.id).last
    @next_photo = @photos.where("id > ?", @photo.id).first

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

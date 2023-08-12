class LikesController < ApplicationController
  def create
    @track = Track.friendly.find(params[:track_id])
    @button_class = current_user.toggle_like!(@track) ? "button-active" : "button"
  end
end

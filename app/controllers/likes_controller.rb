class LikesController < ApplicationController
  
  def create
    @track = Track.friendly.find(params[:track_id])

    if a = current_user.toggle_like!(@track)
      @button_class = "button-active"
    else
      @button_class = "button"
    end

    puts a
  end
end

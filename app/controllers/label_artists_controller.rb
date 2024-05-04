class LabelArtistsController < ApplicationController


  def index
    @label = User.where(role: "artist", label: true).find_by(username: params[:user_id])
  end
end

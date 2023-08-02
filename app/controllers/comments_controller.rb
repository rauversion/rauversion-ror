class CommentsController < ApplicationController

  def create
    if params[:track_id]
      @resource = Track.published.friendly.find(params[:track_id])
    end

    if params[:playlist_id]
      @resource = Playlist.friendly.find(params[:playlist_id])
    end

    @comment = @resource.comments.create(body: params[:comment][:body], user: current_user)
  end
end

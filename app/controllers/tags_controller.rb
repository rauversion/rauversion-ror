class TagsController < ApplicationController


  def index
    @tracks = Track.published.get_tracks_by_tag(params[:tag])
  end
end

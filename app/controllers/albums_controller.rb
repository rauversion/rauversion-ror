class AlbumsController < ApplicationController

  def show
    @release = Release.friendly.find(params[:id])
  end

  def index
  end
end

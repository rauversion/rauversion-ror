class HomeController < ApplicationController


  def index
    @artists = User.artists
    .with_attached_avatar
    .order("id desc").limit(12)
  end
end

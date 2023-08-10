class HomeController < ApplicationController


  def index
    @artists = User.artists.order("id desc").limit(12)
  end
end

class HomeController < ApplicationController
  def index

    set_meta_tags(
      title: "Rauversion",
      description: "Stream Rauversion.",
      image: helpers.image_url("gritt-zheng-uCUkq5H0_Y0-unsplash.jpg")
    )

    @artists = User.artists
      .with_attached_avatar
      .order("id desc").limit(12)
  end
end

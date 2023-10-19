class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_one_attached :cover
  belongs_to :user
  belongs_to :category, optional: true
  has_one_attached :cover
  has_many :comments, as: :commentable

  scope :published, -> {
    where(state: "published")
      .where(private: false)
  }

  scope :draft, -> { where(state: "draft") }

  def cover_url(size = nil)
    url = case size
    when :medium
      cover.variant(resize_to_limit: [200, 200])
      
    when :large
      cover.variant(resize_to_limit: [500, 500])

    when :small
       cover.variant(resize_to_limit: [50, 50])

    when :horizontal
      cover.variant(resize_to_limit: [600, 300])
    else
      cover.variant(resize_to_limit: [200, 200])
    end

    return Rails.application.routes.url_helpers.rails_storage_proxy_url(url) if url.present?


    url || "daniel-schludi-mbGxz7pt0jM-unsplash-sqr-s-bn.png"
  end
  # Ex:- scope :active, -> {where(:active => true)}
end

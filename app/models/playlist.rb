class Playlist < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  has_many :track_playlists
  has_many :tracks, through: :track_playlists
  has_many :listening_events
  has_one_attached :cover
  acts_as_likeable
  has_many :comments, as: :commentable


  accepts_nested_attributes_for :track_playlists, allow_destroy: true

  store_accessor :metadata, :buy_link, :string
  store_accessor :metadata, :buy_link_title, :string
  store_accessor :metadata, :buy, :boolean
  store_accessor :metadata, :record_label, :string

  store_accessor :metadata, :attribution, :boolean
  store_accessor :metadata, :noncommercial, :boolean
  store_accessor :metadata, :non_derivative_works, :boolean
  store_accessor :metadata, :share_alike, :boolean
  store_accessor :metadata, :copies, :string
  store_accessor :metadata, :copyright, :string
  store_accessor :metadata, :price, :decimal
  store_accessor :metadata, :name_your_price, :boolean
  
  def cover_url(size = nil)
    url = case size
      when :medium
        self.cover.variant(resize_to_limit: [200, 200])&.processed&.url

      when :large
        self.cover.variant(resize_to_limit: [500, 500])&.processed&.url

      when :small
        self.cover.variant(resize_to_limit: [50, 50])&.processed&.url

      else
        self.cover.variant(resize_to_limit: [200, 200])&.processed&.url
    end

    url ? url : "daniel-schludi-mbGxz7pt0jM-unsplash-sqr-s-bn.png"
  end

  def album?
    return false if playlist_type.nil?
    playlist_type != "playlist"
  end


  def self.list_playlists_by_user_with_track(track_id, user_id)
    Playlist.select('playlists.*, COUNT(track_playlists.track_id) as track_count')
                  .left_outer_joins(:track_playlists)
                  .where(user_id: user_id, track_playlists: { track_id: [nil, track_id] })
                  .group('playlists.id')
  end

end

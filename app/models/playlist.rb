class Playlist < ApplicationRecord

  class Types
    def self.plain
      [
        "playlist",
        "album",
        "ep",
        "single",
        "compilation"
      ]
    end
  end

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :label, class_name: "User", optional: true

  has_many :track_playlists
  has_many :tracks, through: :track_playlists
  has_many :listening_events
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable
  has_many :products
  has_many :releases

  has_one_attached :cover
  has_one_attached :zip

  acts_as_likeable

  accepts_nested_attributes_for :track_playlists, allow_destroy: true

  belongs_to :label, class_name: "User", optional: true
  attr_accessor :enable_label
  before_save :check_label

  def check_label
   self.label_id = Current.label_user.id if enable_label && Current.label_user 
  end

  scope :latests, -> { order("id desc") }
  scope :published, -> { where(private: false) }
  scope :albums, -> { where(playlist_type: "album") }
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

  def name_your_price?
    name_your_price.present?
  end

  def cover_url(size = nil)
    url = case size
    when :medium
      cover.variant(resize_to_limit: [200, 200])&.processed&.url

    when :large
      cover.variant(resize_to_limit: [500, 500])&.processed&.url

    when :small
      cover.variant(resize_to_limit: [50, 50])&.processed&.url

    else
      cover.variant(resize_to_limit: [200, 200])&.processed&.url
    end

    url || "daniel-schludi-mbGxz7pt0jM-unsplash-sqr-s-bn.png"
  end

  def album?
    return false if playlist_type.nil?
    playlist_type != "playlist"
  end

  def self.list_playlists_by_user_with_track(track_id, user_id)
    #Playlist.select("playlists.*, COUNT(track_playlists.track_id) as track_count")
    #  .left_outer_joins(:track_playlists)
    #  .where(user_id: user_id, track_playlists: {track_id: [nil, track_id]})
    #  .group("playlists.id")


    Playlist
      .select("playlists.*, SUM(CASE WHEN track_playlists.track_id = #{track_id} THEN 1 ELSE 0 END) as track_count")
      .left_outer_joins(:track_playlists)
      .where(user_id: user_id)
      .group("playlists.id")
  end

  def ordered_tracks
   
    tracks.joins(:track_playlists).select('tracks.*, track_playlists.position').distinct.order('track_playlists.position')

  end

  def iframe_code_string(url)
    <<-HTML
      <iframe width="100%" height="100%" scrolling="no" frameborder="no" allow="autoplay" src="#{url}">
      </iframe>
      <div style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;">
        <a href="#{user.username}" title="#{user.username}" target="_blank" style="color: #cccccc; text-decoration: none;">#{user.username}</a> · 
        <a href="#{url}" title="#{title}" target="_blank" style="color: #cccccc; text-decoration: none;">#{title}</a>
      </div>
    HTML
  end
end

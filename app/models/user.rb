class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
        :invitable, :omniauthable, :trackable, :lockable

  has_many :tracks
  has_many :playlists
  has_many :reposts
  has_many :reposted_tracks, through: :reposts, source: :track
  has_many :track_comments
  has_many :posts
  has_many :listening_events
  has_many :invitations, class_name: self.to_s, as: :invited_by
  has_many :oauth_credentials
  has_many :events
  has_many :event_hosts
  has_many :hosted_events, through: :event_hosts

  has_one_attached :profile_header
  has_one_attached :avatar

  acts_as_followable
  acts_as_follower
  acts_as_liker
  acts_as_mentionable

  include User::OmniAuthExtension

  store_attribute :notification_settings, :new_follower_email, :boolean
  store_attribute :notification_settings, :new_follower_app, :boolean
  store_attribute :notification_settings, :repost_of_your_post_email, :boolean
  store_attribute :notification_settings, :repost_of_your_post_app, :boolean
  store_attribute :notification_settings, :new_post_by_followed_user_email, :boolean
  store_attribute :notification_settings, :new_post_by_followed_user_app, :boolean
  store_attribute :notification_settings, :like_and_plays_on_your_post_app, :boolean
  store_attribute :notification_settings, :comment_on_your_post_email, :boolean
  store_attribute :notification_settings, :comment_on_your_post_app, :boolean
  store_attribute :notification_settings, :suggested_content_email, :boolean
  store_attribute :notification_settings, :suggested_content_app, :boolean
  store_attribute :notification_settings, :new_message_email, :boolean
  store_attribute :notification_settings, :new_message_app, :boolean
  store_attribute :notification_settings, :like_and_plays_on_your_post_email, :boolean

  store_attribute :settings, :pst_enabled, :boolean
  store_attribute :settings, :tbk_commerce_code, :string
  store_attribute :settings, :tbk_test_mode, :boolean

  def has_invitations_left?
    true
  end

  def avatar_url(size)
    url = case size
      when :medium
        self.avatar.variant(resize_to_fill: [200, 200])&.processed&.url

      when :large
        self.avatar.variant(resize_to_fill: [500, 500])&.processed&.url

      when :small
        self.avatar.variant(resize_to_fill: [50, 50])&.processed&.url

      else
        self.avatar.variant(resize_to_fill: [200, 200])&.processed&.url
    end

    url ? url : "sai-harish-kjNwiW4BjJE-unsplash-sqr.png"
  end

  def self.track_preloaded_by_user(id)
   # Track.left_outer_joins(:reposts, :likes)
   # .where("reposts.user_id = :id OR likes.liker_id = :id OR reposts.user_id IS NULL OR likes.liker_id IS NULL", id: id)
   # .includes(:audio_blob, :cover_blob, user: :avatar_attachment)

   tracks = Track.arel_table
   users = User.arel_table
   reposts_alias = Repost.arel_table.alias('r')
   likes_alias = Like.arel_table.alias('l')
   
   reposts_join = tracks
     .join(reposts_alias, Arel::Nodes::OuterJoin)
     .on(reposts_alias[:track_id].eq(tracks[:id])
     .and(reposts_alias[:user_id].eq(id)))
     .join_sources
   
   likes_join = tracks
     .join(likes_alias, Arel::Nodes::OuterJoin)
     .on(likes_alias[:likeable_id].eq(tracks[:id])
     .and(likes_alias[:likeable_type].eq("Track"))
     .and(likes_alias[:liker_id].eq(id))
     .and(likes_alias[:liker_type].eq('User'))
    )
     .join_sources
   
   result = Track.includes(:audio_blob, :cover_blob, user: :avatar_attachment)
     .joins(reposts_join, likes_join)
     .select('tracks.*, r.id as repost_id, l.id as like_id')
     .references(:r, :l)
  end

  def reposts_preloaded
    User.track_preloaded_by_user(self.id)
    .joins(:reposts)
    .where("reposts.user_id =?", self.id)
  end

  def is_admin?
    role == "admin"
  end

  def profile_header_url(size)
    url = case size
      when :medium
        self.profile_header.variant(resize_to_fill: [200, 200])&.processed&.url

      when :large
        self.profile_header.variant(resize_to_fill: [500, 500])&.processed&.url

      when :small
        self.profile_header.variant(resize_to_fill: [50, 50])&.processed&.url

      else
        self.profile_header.variant(resize_to_fill: [200, 200])&.processed&.url
    end

    url ? url : "sai-harish-kjNwiW4BjJE-unsplash-sqr.png"
  end

  def is_admin?
    role == "admin"
  end

  def is_creator?
    role == "artist" || role == "admin"
  end
end

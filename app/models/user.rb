class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: { user: 'user', admin: 'admin', artist: 'artist' }
  
  devise :invitable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable,
    :invitable, :omniauthable, :trackable, :lockable

  has_many :tracks
  has_many :playlists
  has_many :reposts
  has_many :reposted_tracks, through: :reposts, source: :track
  has_many :track_comments
  has_many :posts
  has_many :photos
  has_many :listening_events
  has_many :invitations, class_name: to_s, as: :invited_by
  has_many :oauth_credentials
  has_many :events
  has_many :event_hosts
  has_many :hosted_events, through: :event_hosts
  has_many :purchases
  has_many :comments
  has_one :podcaster_info

  
  has_many :connected_accounts, foreign_key: :parent_id

  has_many :child_accounts, through: :connected_accounts, source: :user

  has_many :spotlights, autosave: true
  # has_many :spotlighted_tracks, through: :spotlight_tracks, source: :spotlight_tracks
  has_one_attached :profile_header
  has_one_attached :avatar

  acts_as_followable
  acts_as_follower
  acts_as_liker
  acts_as_mentionable


  normalizes :username, with: -> username { username.parameterize }

  validates_presence_of :username, on: :update, message: "can't be blank"

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

  store_attribute :settings, :hide_username_from_profile, :boolean
  store_attribute :settings, :pst_enabled, :boolean
  store_attribute :settings, :tbk_commerce_code, :string
  store_attribute :settings, :tbk_test_mode, :boolean

  accepts_nested_attributes_for :photos, allow_destroy: true

  scope :artists, -> { where(role: "artist").where.not(username: nil) }
  
  
  def full_name
    [first_name, last_name].compact.join(" ")
  end
  # Ex:- scope :active, -> {where(:active => true)}
  def has_invitations_left?
    true
  end

  def avatar_url(size = :medium)
    url = case size
    when :medium
      avatar.variant(resize_to_fill: [200, 200]) # &.processed&.url

    when :large
      avatar.variant(resize_to_fill: [500, 500]) # &.processed&.url

    when :small
      avatar.variant(resize_to_fill: [50, 50]) # &.processed&.url

    else
      avatar.variant(resize_to_fill: [200, 200]) # &.processed&.url
    end

    url || "daniel-schludi-mbGxz7pt0jM-unsplash-sqr-s-bn.png"
  end

  def self.track_preloaded_by_user(current_user_id:, user: )
    # Track.left_outer_joins(:reposts, :likes)
    # .where("reposts.user_id = :id OR likes.liker_id = :id OR reposts.user_id IS NULL OR likes.liker_id IS NULL", id: id)
    # .includes(:audio_blob, :cover_blob, user: :avatar_attachment)
    # user = User.find(id)
    tracks = Track.arel_table
    users = User.arel_table
    reposts_alias = Repost.arel_table.alias("r")
    likes_alias = Like.arel_table.alias("l")

    reposts_join = tracks
      .join(reposts_alias, Arel::Nodes::OuterJoin)
      .on(reposts_alias[:track_id].eq(tracks[:id])
      .and(reposts_alias[:user_id].eq(current_user_id)))
      .join_sources

    likes_join = tracks
      .join(likes_alias, Arel::Nodes::OuterJoin)
      .on(likes_alias[:likeable_id].eq(tracks[:id])
      .and(likes_alias[:likeable_type].eq("Track"))
      .and(likes_alias[:liker_id].eq(current_user_id))
      .and(likes_alias[:liker_type].eq("User")))
      .join_sources

    if !user.label
      result = Track.includes(:audio_blob, :cover_blob, user: :avatar_attachment)
        .joins(reposts_join, likes_join)
        .where(tracks[:user_id].eq(user.id))
        .select("tracks.*, r.id as repost_id, l.id as like_id")
        .references(:r, :l)
      return result
    else

      # Gather child account IDs
      # child_ids = User.find(id).child_accounts.pluck(:id)

      # Adjust where clause to include tracks from child accounts
      result = Track.includes(:audio_blob, :cover_blob, user: :avatar_attachment)
                    .joins(reposts_join, likes_join)
                    .where(tracks[:user_id].eq(user.id).or(tracks[:label_id].in(user.id)))
                    .select("tracks.*, r.id as repost_id, l.id as like_id")
                    .references(:r, :l)
    end

  end

  def self.track_preloaded_by_user_n(user:)
    tracks = Track.arel_table
    users = User.arel_table

    if !user.label
      result = Track.includes(:audio_blob, :cover_blob, user: :avatar_attachment)
      .where(tracks[:user_id].in(user.id))
      return result
    else
      # Gather child account IDs
      # Adjust where clause to include tracks from child accounts
      result = Track.includes(:audio_blob, :cover_blob, user: :avatar_attachment)
      .where(tracks[:user_id].in(user.id).or(tracks[:label_id].in(user.id)))
    end

  end

  def reposts_preloaded(current_user: nil)
    tracks = current_user.blank? ?
    User.track_preloaded_by_user_n(user: self) :
    User.track_preloaded_by_user(current_user_id: current_user, user: self)
    tracks.joins(:reposts).where("reposts.user_id =?", id)
  end

  def is_publisher?
    is_admin?
  end

  def is_admin?
    role == "admin"
  end

  def profile_header_url(size)
    url = case size
    when :medium
      profile_header.variant(resize_to_fill: [600, 200])&.processed&.url

    when :large
      profile_header.variant(resize_to_fill: [1200, 500])&.processed&.url

    when :small
      profile_header.variant(resize_to_fill: [300, 100])&.processed&.url

    else
      profile_header.variant(resize_to_fill: [300, 100])&.processed&.url
    end

    url || "daniel-schludi-mbGxz7pt0jM-unsplash-sqr-s-bn.png"
  end

  def is_creator?
    username.present? && role == "artist" || role == "admin"
  end

  def user_sales_for(kind = "Track")
    purchased_items = PurchasedItem.joins(
      "INNER JOIN tracks ON purchased_items.purchased_item_id = tracks.id AND purchased_items.purchased_item_type = '#{kind}'"
    )
      .where(tracks: {user_id: id})
  end


  def active_connected_accounts(user)
    ConnectedAccount.where(parent_id: user.id, state: 'active').includes(:user)
  end

  def is_child_of?(child_user_id)
    ConnectedAccount.exists?(parent_id: self.id, state: 'active', user_id: child_user_id)
  end

  def to_combobox_display
    self.username
  end

  def find_artists_excluding_children(q = nil)
    # Get IDs of all child accounts for the current user
    child_account_ids = self.child_accounts.pluck(:id)
  
    # Base query adjusted to exclude child account IDs
    artists = User.where(role: "artist")
                  .where.not(username: nil)
                  #.where.not(label: true)
                  .where.not(id: child_account_ids)
  
    # Apply search filter if 'q' is provided
    if q.present?
      artists = artists.where("username ILIKE :q OR email ILIKE :q", q: "%#{q}%")
    end
  
    artists
  end

  def self.ransackable_attributes(auth_object = nil)
    ["bio", "city", "confirmation_sent_at", "confirmation_token", "confirmed_at", "country", "created_at", "current_sign_in_at", "current_sign_in_ip", "editor", "email", "encrypted_password", "failed_attempts", "first_name", "id", "id_value", "invitation_accepted_at", "invitation_created_at", "invitation_limit", "invitation_sent_at", "invitation_token", "invitations_count", "invited_by_id", "invited_by_type", "label", "last_name", "last_sign_in_at", "last_sign_in_ip", "locked_at", "notification_settings", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role", "settings", "sign_in_count", "support_link", "unconfirmed_email", "unlock_token", "updated_at", "username"]
  end

  # def password_required?
  #  false
  # end
end
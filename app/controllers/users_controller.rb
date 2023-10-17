class UsersController < ApplicationController
  before_action :find_user, except: [:index]
  before_action :check_user_role, except: [:index]

  def index
    @artists = User.where(role: "artist")
    .where.not(username: nil)
    .with_attached_avatar
    .order("id desc")
    .page(params[:page]).per(params[:per])
  end

  def show
    get_tracks
    get_meta_tags
    @as = :track
    @section = "tracks/track_item"
  end

  def tracks
    get_tracks
    # @collection = @user.tracks.page(params[:page]).per(5)
    @as = :track
    @title = "Tracks"
    @section = "tracks/track_item"

    paginated_render
  end

  def playlists
    @title = "Playlists"
    @section = "playlists"
    @collection = @user.playlists
    .where.not(playlist_type: ["album", "ep"])
    .with_attached_cover
    .includes(user: {avatar_attachment: :blob})
    .includes(tracks: {cover_attachment: :blob})

    if current_user.blank? || current_user != @user
      @collection = @collection.where(private: false)
    end

    @collection = @collection.references(:tracks)
    .page(params[:page])

    #@collection = @collection
    #.where(
    #  playlists: {user_id: @user.id}, 
    #  tracks: {user_id: @user.id}
    #) if current_user.present?

    #.or(
    #  @user.playlists
    #  .where(
    #    playlists: {private: true}, 
    #    tracks: {private: true, user_id: @user.id}
    #  )
    #)
    #.or(
    #  @user.playlists
    #  .where.not(
    #    playlists: {user_id: @user.id}, 
    #    tracks: {user_id: @user.id}
    #  )
    #  .where(tracks: {private: true})
    #)
      
    @as = :playlist
    @section = "playlists/playlist_item"
    render "show"
  end

  def reposts
    @title = "Reposts"
    @collection = @user.reposts_preloaded.page(params[:page]).per(5)
    @as = :track
    @section = "tracks/track_item"
    render "show"
  end

  def albums
    @title = "Albums"
    @section = "albums"
    @collection = @user.playlists
      .where(playlist_type: ["album", "ep"])
      .where(user_id: @user.id)
      .with_attached_cover
      .includes(user: {avatar_attachment: :blob})
      .includes(tracks: {cover_attachment: :blob})

    if current_user.blank? || current_user != @user
      @collection = @collection.where(private: false)
    end

    @collection = @collection.page(params[:page]).per(5)
    @as = :playlist
    @section = "playlists/playlist_item"
    render "show"
  end

  private

  def get_meta_tags
    set_meta_tags(
      # keywords: @user.tags.join(", "),
      # url: Routes.articles_show_url(socket, :show, track.id),
      title: "#{@user.username} on Rauversion",
      description: "Stream #{@user.username} on Rauversion.",
      image: @user.avatar_url(:small)
    )
  end

  def get_tracks
    # @collection = @user.tracks.page(params[:page]).per(2)
    @collection = if current_user
      User.track_preloaded_by_user(current_user&.id)
        .where(user_id: @user.id)
        .with_attached_cover
        .includes(user: {avatar_attachment: :blob})
        .order("id desc")
        .page(params[:page]).per(6)
    else
      @user.tracks.published
        .with_attached_cover
        .includes(user: {avatar_attachment: :blob})
        .order("id desc").page(params[:page]).per(6)
    end
  end

  def find_user
    @user = User.find_by(username: params[:id] || params[:user_id])
  end

  def paginated_render
    unless params[:page]
      render "show"
    end

    if params[:page]
      render turbo_stream: [
        turbo_stream.prepend(
          "paginated-list",
          partial: @section,
          collection: @collection,
          as: @as
        ),
        turbo_stream.replace(
          "list-pagination",
          partial: "item_pagination"
        )
      ]
    end
  end

  def check_user_role
    redirect_to root_url, notice: "The profile you are trying to access is not activated" and return unless @user.is_creator?
  end
end

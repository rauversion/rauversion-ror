class UsersController < ApplicationController

  before_action :find_user

  def show
    get_tracks
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
    .where(user_id: @user.id )
    .with_attached_cover
    .includes(user: { avatar_attachment: :blob })
    .includes(tracks: {cover_attachment: :blob})
    .page(params[:page]).per(5)
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
      .where(user_id: @user.id )
      .with_attached_cover
      .includes(user: { avatar_attachment: :blob })
      .includes(tracks: {cover_attachment: :blob})
      .page(params[:page]).per(5)
    @as = :playlist
    @section = "playlists/playlist_item"
    render "show"
  end

  private

  def get_tracks
    # @collection = @user.tracks.page(params[:page]).per(2)
    if current_user 
      @collection = User.track_preloaded_by_user(current_user&.id)
        .where(user_id: @user.id )
        .with_attached_cover
        .includes(user: { avatar_attachment: :blob })
        .order("id desc")
        .page(params[:page]).per(6)
    else
      @collection = @user.tracks.published
      .with_attached_cover
      .includes(user: { avatar_attachment: :blob })
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
end

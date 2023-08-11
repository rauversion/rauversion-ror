class UsersController < ApplicationController

  before_action :find_user

  def show
    @collection = @user.tracks.page(params[:page]).per(2)
    @as = :track
    @section = "tracks/track_item"
  end

  def tracks

    # @collection = @user.tracks.page(params[:page]).per(2)
    if current_user 
      @collection = User.track_preloaded_by_user(current_user&.id)
        .where(user_id: @user.id )
        .order("id desc")
        .page(params[:page]).per(2)
    else
      @collection = @user.tracks.published.order("id desc").page(params[:page]).per(2)
    end
    # @collection = @user.tracks.page(params[:page]).per(5)
    @as = :track
    @section = "tracks/track_item"

    paginated_render
  end

  def playlists
    @section = "playlists"
    @collection = @user.playlists.page(params[:page]).per(5)
    @as = :playlist
    @section = "playlists/playlist_item"
    render "show"
  end

  def reposts
    @collection = @user.reposts_preloaded.page(params[:page]).per(5)
    @as = :track
    @section = "tracks/track_item"
    render "show"
  end

  def albums
    @section = "albums"
    @collection = @user.playlists.where(playlist_type: "album").page(params[:page]).per(5)
    @as = :playlist
    @section = "playlists/playlist_item"
    render "show"
  end

  private

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

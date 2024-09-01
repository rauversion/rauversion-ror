class PlayerController < ApplicationController
  def update
    @tracks = Track.where(id: params[:player][:ids])
      .with_attached_cover
      .includes(user: {avatar_attachment: :blob})
  end

  def show
    id = params[:id]
    @track = Track.friendly.find(id)

    render status: :ok and return if @track.blank? 
    # @next_track = next_track(@track.id)
    # @prev_track = previous(@track.id)

    if params[:t]
      render turbo_stream: [


        turbo_stream.update(
          "player-frame",
          partial: "player",
          locals: {track: @track}
        )

        #turbo_stream.update(
        #  "track-info-wrapper",
        #  partial: "track_info",
        #  locals: {track: @track}
        #)
      ]
    end
  end

  def next_track(id)
    Track.where("id > ?", id).order(id: :asc).first
      .with_attached_cover
      .includes(user: {avatar_attachment: :blob})
  end

  def previous(id)
    Track.where("id < ?", id).order(id: :desc).first
      .with_attached_cover
      .includes(user: {avatar_attachment: :blob})
  end
end

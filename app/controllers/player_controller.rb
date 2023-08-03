class PlayerController < ApplicationController

  def show
    id = params[:id]
    @track = Track.friendly.find(id)
    @next_track = next_track(@track.id)
    @prev_track = previous(@track.id)

    if params[:t] 
      render turbo_stream: [
        
        turbo_stream.update(
          "track-info-wrapper",
          partial: "track_info",
          locals: {track: @track}
        )
      ]
    end
  end



  def next_track(id)
    Track.where("id > ?", id).order(id: :asc).first
  end

  def previous(id)
    Track.where("id < ?", id).order(id: :desc).first
  end
end

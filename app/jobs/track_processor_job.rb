class TrackProcessorJob < ApplicationJob
  queue_as :default

  def perform(track_id)
    track = Track.find(track_id)
    track.reprocess!
  end
end

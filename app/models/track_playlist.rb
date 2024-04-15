class TrackPlaylist < ApplicationRecord
  belongs_to :playlist
  belongs_to :track

  acts_as_list scope: [:playlist_id]

end

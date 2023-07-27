class TrackPlaylist < ApplicationRecord
  belongs_to :playlist
  belongs_to :track
end

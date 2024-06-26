class PortPeaks < ActiveRecord::Migration[7.0]
  def change

    Track.all.find_each do |track|

      next if track&.peaks&.any?
      peaks = track.metadata["peaks"] rescue []
      track.build_track_peak(data: peaks)
      track.update(peaks: [])
    end
  end
end

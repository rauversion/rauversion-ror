class PortPeaks < ActiveRecord::Migration[7.0]
  def change

    Track.all.find_each do |track|

      track.build_track_peak(data: track.metadata["peaks"])
      track.update(peaks: [])
    end
  end
end

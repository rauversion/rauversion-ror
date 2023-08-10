require "zip"

class ZipperJob < ApplicationJob
  queue_as :default

  def perform(track_id: nil, playlist_id: nil)
    if track_id
      track = Track.find_by(id: track_id)
      return unless track
      track_zip(track)
    elsif playlist_id
      playlist = Playlist.find_by(id: playlist_id)
      return unless playlist
      playlist_zip(playlist)
    else
      Rails.logger.warn "ZipperJob called without track_id or playlist_id."
    end
  rescue StandardError => e
    Rails.logger.error "Failed to zip: #{e.message}"
  end

  private

  def track_zip(record)
    # Ensure the audio is attached
    unless record.audio.attached?
      Rails.logger.warn "Track #{record.id} has no attached audio."
      return
    end

    # Download the audio in chunks and save to a temp file
    audio_path = Rails.root.join('tmp', record.audio.filename.to_s)
    record.audio.download do |chunk|
      File.open(audio_path, 'ab') do |file|
        file.write(chunk)
      end
    end

    # Zip the audio
    zipfile_path = Rails.root.join('tmp', "#{record.audio.filename.base}.zip")
    Zip::File.open(zipfile_path, Zip::File::CREATE) do |zipfile|
      zipfile.add(record.audio.filename.to_s, audio_path)
    end

    # Attach the zipped file to the record
    record.zip.attach(io: File.open(zipfile_path), filename: "#{record.audio.filename.base}.zip", content_type: "application/zip")

    # Clean up temporary files
    File.delete(audio_path)
    File.delete(zipfile_path)
  rescue => e
    Rails.logger.error "Error zipping track #{record.id}: #{e.message}"
  end


  def playlist_zip(playlist)
    zipfile_path = Rails.root.join('tmp', "#{playlist.slug}-#{playlist.id}.zip")

    Zip::File.open(zipfile_path, Zip::File::CREATE) do |zipfile|
      playlist.tracks.each do |track|
        next unless track.audio.attached?

        audio_path = Rails.root.join('tmp', track.slug)
        track.audio.download do |chunk|
          File.open(audio_path, 'ab') { |file| file.write(chunk) }
        end

        zipfile.add(track.audio.filename.to_s, audio_path)
        File.delete(audio_path) # Clean up the downloaded audio file
      end
    end

    # Here you can attach the zipped file to the playlist or whatever you want
    # e.g. 
    playlist.zip.attach(
      io: File.open(zipfile_path), 
      filename: "#{playlist.slug}.zip"
    )
    # or store it somewhere else or let the user download it directly.

    # Clean up the generated zip file if you're not attaching it
    File.delete(zipfile_path)
  end
end
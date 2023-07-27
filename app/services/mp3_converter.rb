require 'tempfile'

class Mp3Converter
  def initialize(file)
    @file = file
  end

  def run
    dir = Dir.mktmpdir("my-dir")

    filename = File.basename(@file, File.extname(@file))

    output_file = "#{dir}/#{filename}.mp3"

    output = %x(#{ffmpeg_path} -i #{@file} -vn -ar 44100 -ac 2 -b:a 192k #{output_file})

    puts output

    puts "OUTPUT EXISTS? #{File.exist?(output_file)}"

    output_file
    #ensure
    #FileUtils.remove_entry dir
  end

  private

  def ffmpeg_path
    "ffmpeg"
  end
end
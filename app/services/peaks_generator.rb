class PeaksGenerator
  def initialize(file, duration = 20)
    @file = file
    @duration = duration
    @desired_waveform_width = 800
  end

  def run
    case ENV['PEAKS_PROCESSOR']
    when "audiowaveform"
      run_audiowaveform
    else
      run_ffprobe
    end
  end

  private

  def run_audiowaveform
    desired_pixels = 10
    pixels_per_second = calculate_pixels_per_second

    puts "pixels_per_second: #{pixels_per_second}"

    output = %x(#{audiowaveform_path} -i #{@file} --input-format mp3 --pixels-per-second #{pixels_per_second} -b 8 --output-format json -)

    puts output

    result = JSON.parse(output)
    data = result['data']

    normalize(data)
  rescue JSON::ParserError => e
    puts "Error parsing JSON: #{e.message}"
    []
  end

  def run_ffprobe
    puts "processing #{@file}"

    pixels_per_frame = @duration * 75
    cmd = "#{ffprobe_path} -v error -f lavfi -i amovie=#{@file},asetnsamples=n=#{pixels_per_frame}:p=0,astats=metadata=1:reset=1 -show_entries frame_tags=lavfi.astats.Overall.Peak_level -of json"

    puts cmd
    output = %x(#{cmd})

    result = JSON.parse(output)
    frames = result["frames"]

    frames.map do |x|
      peak_level = x.dig("tags", "lavfi.astats.Overall.Peak_level")
      Float(peak_level) rescue nil
    end.compact.then(&method(:normalize))
  rescue JSON::ParserError => e
    puts "Error parsing JSON: #{e.message}"
    []
  end

  def calculate_pixels_per_second
    (@desired_waveform_width / @duration).round
  end

  def normalize(input)
    min, max = input.minmax
    new_min, new_max = [-1.0, 1.0]

    input.map do |x|
      new_min + ((x - min) / (max - min)) * (new_max - new_min)
    end.map { |x| x.round(3) }
  end

  def ffprobe_path
    "ffprobe"
  end

  def audiowaveform_path
    "audiowaveform"
  end
end
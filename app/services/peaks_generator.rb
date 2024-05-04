class PeaksGenerator
  def initialize(file, duration = 20)
    @file = file
    @duration = duration
    @desired_waveform_width = 800
  end

  def run
    case ENV["PEAKS_PROCESSOR"]
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

    output = `#{audiowaveform_path} -i #{@file} --input-format mp3 --pixels-per-second #{pixels_per_second} -b 8 --output-format json -`

    puts output

    result = JSON.parse(output)
    data = result["data"]

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
    output = `#{cmd}`
  
    result = JSON.parse(output)
    frames = result["frames"]
  
    frames.map do |x|
      peak_level_db = x.dig("tags", "lavfi.astats.Overall.Peak_level")
      begin
        # Convert dB to linear scale
        peak_level_linear = 10 ** (Float(peak_level_db) / 20)
        peak_level_linear
      rescue
        nil
      end
    end.compact.then(&method(:normalize))
  rescue JSON::ParserError => e
    puts "Error parsing JSON: #{e.message}"
    []
  end

  def calculate_pixels_per_second
    (@desired_waveform_width / @duration).round
  end

  def normalize(input)
    # Find the maximum absolute value in the array
    max_abs_value = input.map(&:abs).max.to_f

    # Normalize each value in the inputay
    input.map { |val| val / max_abs_value }
  end

  def ffprobe_path
    "ffprobe"
  end

  def audiowaveform_path
    "audiowaveform"
  end
end

require "faker"
namespace :utils do


  desc "Create a user with a role of 'artist' and an attached avatar"
  task gen_artists: :environment do

      # Ask for the number of users to create
      puts "Enter the number of users to create:"
      number_of_users = 30 # STDIN.gets.chomp.to_i
  
      number_of_users.times do |i|
        name = Faker::Name.name
        username = Faker::Internet.username(specifier: name, separators: %w(. _ -))
        role = "artist"
  
        user = User.new(
          username: username, 
          role: role, 
          password: "123456", 
          password_confirmation: "123456",
          email: Faker::Internet.email
        )
  
        avatar_path = Rails.root.join('lib', 'tasks', 'avatars', 'default_avatar.png')
        user.avatar.attach(io: File.open(avatar_path), filename: "default_avatar_#{i}.png", content_type: 'image/jpeg')
  
        if user.save
          puts "User '#{name}' with username '#{username}' and role '#{role}' was successfully created."
        else
          puts "Failed to create user: #{user.errors.full_messages.join(", ")}"
        end
      end
 
  end


  # use: rake utils:gen_qr'[url=https://example.com,path=custom-qrcode]'
  desc "create qr code"
  task :gen_qr, [:url, :path] do |t, args|
    require "rqrcode"
  
    # Set default values if options are not provided
    url = args[:url]
    path = "/tmp/#{args[:path]}.png" || "/tmp/#{SecureRandom.hex(4)}.png"
  
    qrcode = RQRCode::QRCode.new(url)
  
    # NOTE: showing with default options specified explicitly
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 500
    )
  
    IO.binwrite(path, png.to_s)
    puts "QR code generated at #{path}"
  end

end
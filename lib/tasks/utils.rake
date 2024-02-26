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
end
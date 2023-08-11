
require 'sequel'

# Example for PostgreSQL
DB = Sequel.connect(
  adapter: :postgres,
  user: ENV["PHX_DB_USER"],
  password: ENV["PHX_DB_PASS"],
  host: ENV["PHX_DB_HOST"],
  port: 25061,
  database: ENV["PHX_DB_DB"],
  sslmode: "require"
) rescue nil


def create_users
  DB.fetch('SELECT * FROM users') do |row|
    u = User.create(
      id: row[:id],
      email: row[:email],
      username: row[:username],
      role: row[:type],
      bio: row[:bio],
      first_name: row[:first_name],
      last_name: row[:last_name],
      settings: row[:settings] ? JSON.parse(row[:settings]) : nil,
      invited_by_id: row[:invited_by],
      invited_by_type: row[:invited_by].present? ? User : nil,
      city: row[:city],
      country: row[:country]
    )

    puts u.errors.full_messages
  end
end

def create_oauth_credentials
  DB.fetch('SELECT * FROM oauth_credentials') do |row|
    o = OauthCredential.create(
      id: row[:id],
      uid: row[:uid],
      token: row[:token],
      provider: row[:provider],
      data: JSON.parse(row[:data]),
      user_id: row[:user_id]
    )
    puts o.errors.full_messages
  end
end

def create_follows
  DB.fetch('SELECT * FROM user_follows') do |row|
    u = User.find(row[:follower_id])
    u.follow!(User.find(row[:following_id]))
  end
end

def parse_array(str)
  # Remove the outer curly braces
  cleaned_str = str[1..-2]

  # Split the string by commas that are not inside quotes
  parsed_array = cleaned_str.split(/,(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)/).map do |item|
    # Remove quotes from items
    item.gsub(/\"/, '').strip
  end
end

def create_tracks
  DB.fetch("SELECT * FROM tracks") do |row|
    t = Track.create(
      id: row[:id], 
      title: row[:title], 
      description: row[:description], 
      private: row[:private], 
      slug: row[:slug], 	
      caption: row[:caption], 
      notification_settings: row[:notification_settings] ? JSON.parse(row[:notification_settings]) : nil, 
      metadata: row[:metadata] ? JSON.parse(row[:metadata]) : nil, 
      user_id: row[:user_id],
      created_at: row[:inserted_at],     
      updated_at: row[:updated_at],      
      likes_count: row[:likes_count],     
      reposts_count: row[:reposts_count],   
      state: row[:state],           
      tags: row[:tags] ? parse_array(row[:tags]) : []
    )
    
    puts t.errors.full_messages
  end
end

def create_playlists
  DB.fetch("select * from playlists") do |row|
    t = Playlist.create(
      id: row[:id],               	
      slug: row[:slug],               
      description: row[:description],        
      title: row[:title],              
      metadata: row[:metadata] ? JSON.parse(row[:metadata]) : {},           
      user_id: row[:user_id],            
      created_at: row[:inserted_at],        
      updated_at: row[:updated_at],         
      private: row[:private],            
      playlist_type: row[:playlist_type],      
      genre: row[:genre],              
      release_date: row[:release_date],       
      likes_count: row[:likes_count],        
      custom_genre: row[:custom_genre],       
      tags: row[:tags] ? parse_array(row[:tags]) : []           
    )
    puts t.errors.full_messages                   
  end
end

def track_likes
  DB.fetch("select * from track_likes") do |row|

    t = Like.create({
      id: row[:id],                     	
      liker_type: "User",
      liker_id: row[:user_id],
      likeable_type: "Track",
      likeable_id: row[:track_id], 
      created_at: row[:inserted_at],    
    })
  end
end

def track_playlists
  DB.fetch("select * from track_playlists") do |row|
    t = TrackPlaylist.create(
      {
        id: row[:id],       	       
        track_id: row[:track_id],       	  
        playlist_id: row[:playlist_id],       	
        created_at: row[:inserted_at],       	
        updated_at: row[:updated_at],       	
      }
    )
    t.errors.full_messages
  end
end

def track_comments
  DB.fetch("select * from track_comments") do |row|
    t = Comment.create({
      id: row[:id],           	
      body: row[:body],           
      # track_minute: row[:track_minute],   
      # state: row[:state],          
      user_id: row[:user_id],        
      commentable_id: row[:track_id], 
      commentable_type: "Track",     
      created_at: row[:inserted_at],    
      updated_at: row[:updated_at]  
    })
    puts t.errors.full_messages 
  end
end

def create_reposts
  DB.fetch("select * from reposts") do |row|
    t = Repost.create({
      id: row[:id],
      user_id: row[:user_id],
      track_id: row[:track_id],
      created_at: row[:inserted_at],
      updated_at: row[:updated_at]
    })
    puts t.errors.full_messages
  end
end

def create_posts
  DB.fetch("select * from posts") do |row|
    t = Post.create({
      id: row[:id],         	
      title: row[:title],        
      body: JSON.parse(row[:body]),         
      settings: row[:settings] ? JSON.parse(row[:settings]) : {},     
      private: row[:private],      
      excerpt: row[:excerpt],      
      slug: row[:slug],         
      state: row[:state],        
      user_id: row[:user_id],      
      created_at: row[:inserted_at],  
      updated_at: row[:updated_at],   
      category_id: row[:category_id]
    })
  end
end

def create_categories
  DB.fetch("select * from categories") do |row|
    t = Category.create({
      id: row[:id],      	
      name: row[:name],     
      slug: row[:slug],     
      created_at: row[:inserted_at],
      updated_at: row[:updated_at],
    })
    puts t.errors.full_messages 
  end
end

def create_events
  DB.fetch("select * from events") do |row|
    schedule_settings = row[:scheduling_settings] ? JSON.parse(row[:scheduling_settings]) : []
    
    schedule_settings = schedule_settings.map do |item|
      {
        name: item["name"],
        start_date: item["start_date"],
        end_date: item["end_date"],
        description: item["description"],
        schedule_type: s["schedule_type"],
        schedule_schedulings_attributes: item["schedulings"].map do |s|
          {
            name: s["title"],
            start_date: s["start_date"],
            end_date: s["end_date"],
            short_description: s["short_description"]
          }
        end
      }
    end

    streaming_service = row[:streaming_service] ? JSON.parse(row[:streaming_service]) : {}
    
    streaming_service.merge!(
      {
        type: streaming_service["__type__"]
      }
    ) unless streaming_service.empty?
    
    t = Event.create({
      id: row[:id],                
      title: row[:title],                
      description: row[:description],          
      slug: row[:slug],                 
      state: row[:state],                
      timezone: row[:timezone],             
      event_start: row[:event_start],          
      event_ends: row[:event_ends],           
      private: row[:private],              
      online: row[:online],               
      location: row[:location],             
      street: row[:street],               
      street_number: row[:street_number],        
      lat: row[:lat],                  
      lng: row[:lng],                  
      venue: row[:venue],                
      country: row[:country],              
      city: row[:city],                 
      province: row[:province],             
      postal: row[:postal],               
      age_requirement: row[:age_requirement],      
      event_capacity: row[:event_capacity],       
      event_capacity_limit: row[:event_capacity_limit], 
      eticket: row[:eticket],                  	
      will_call: row[:will_call],                  
      order_form: row[:order_form],                 
      widget_button: row[:widget_button],             
      event_short_link: row[:event_short_link],           
      tax_rates_settings: row[:tax_rates_settings],        
      attendee_list_settings: row[:attendee_list_settings],     
      event_schedules_attributes: schedule_settings,        
      event_settings: row[:event_settings] ? JSON.parse(row[:event_settings]) : nil,            
      tickets: row[:tickets],                  
      user_id: row[:user_id],                  	
      created_at: row[:inserted_at],                
      updated_at: row[:updated_at],                
      streaming_service: streaming_service
    })

    debugger
  end
end

def event_recordings
  DB.fetch("select * from event_recordings") do |row|
    t = EventRecording.create({
      id: row[:id],
      type: row[:type],
      title: row[:title],
      description: row[:description],
      iframe: row[:iframe],
      properties: row[:properties],
      position: row[:position],
      event_id: row[:event_id],
      created_at: row[:inserted_at],
      updated_at: row[:updated_at]
    })
  end
end

def event_tickets
  DB.fetch("select * from event_tickets") do |row|
    t = EventTicket.create({
      id: row[:id],                              
      title: row[:title],                         
      price: row[:price],                          
      early_bird_price: row[:early_bird_price],   
      standard_price: row[:standard_price],       
      qty: row[:qty],                       
      selling_start: row[:selling_start],         
      selling_end: row[:selling_end],         
      short_description: row[:short_description],
      settings: JSON.parse(row[:settings]),      
      event_id: row[:event_id],     
      created_at: row[:inserted_at],     
      updated_at: row[:updated_at]
    })
    puts t.errors.full_messages
  end
end

def event_hosts
  DB.fetch("select * from event_host") do |row|
    t = EventHost.create({
      id: row[:id],
      name: row[:name],
      description: row[:description],
      event_id: row[:event_id],
      user_id: row[:user_id],
      listed_on_page: row[:listed_on_page],
      event_manager: row[:event_manager],
      created_at: row[:inserted_at],
      updated_at: row[:updated_at]
    })
    puts t.errors.full_messages
  end
end

def listening_events
  DB.fetch("select * from listening_events") do |row|
    t = ListeningEvent.create({
      id: row[:id],
      remote_ip: row[:remote_ip],
      country: row[:country],
      city: row[:city],
      ua: row[:ua],
      lang: row[:lang],
      referer: row[:referer],
      utm_medium: row[:utm_medium],
      utm_source: row[:utm_source],
      utm_campaign: row[:utm_campaign],
      utm_content: row[:utm_content],
      utm_term: row[:utm_term],
      browser_name: row[:browser_name],
      browser_version: row[:browser_version],
      modern: row[:modern], 
      platform: row[:platform],
      device_type: row[:device_type],
      bot: row[:bot],
      search_engine: row[:search_engine],              
      resource_profile_id: row[:resource_profile_id],
      user_id: row[:user_id],                          
      track_id: row[:track_id],                        
      playlist_id: row[:playlist_id],                  
      created_at: row[:inserted_at],                    
      updated_at: row[:updated_at]
    })
    puts t.errors.full_messages
  end
end

def preview_cards
  DB.fetch("select * from preview_cards") do |row|
    t = PreviewCard.create({
      id: row[:id],
      url: row[:url],
      title: row[:title],
      description: row[:description],
      type: row[:type],
      author_name: row[:author_name],
      author_url: row[:author_url],
      html: row[:html],
      image: row[:image],
      created_at: row[:inserted_at],
      updated_at: row[:updated_at],
    })
    puts t.errors.full_messages
  end
end

def event_purchase_orders
  DB.fetch("SELECT tpo.*,  po.* FROM track_purchase_orders AS tpo INNER JOIN purchase_orders AS po ON tpo.purchase_order_id = po.id;") do |row|
    puts row
    # t = Purchase.create({
    #   id: row[:id],
    #   user_id: row[:user_id],
    #   created_at: row[:created_at],
    #   updated_at: row[:updated_at],
    #   state: row[:state],
    #   checkout_type: row[:checkout_type],
    #   checkout_id: row[:checkout_id],
    #   purchasable_type: row[:purchasable_type]
    #   purchasable_id: row[:purchasable_id],
    # })
  end
end

def create_blobs
  DB.fetch("select * from active_storage_blobs") do |row|
    t = ActiveStorage::Blob.insert_all(
      [{
        id: row[:id],
        key: row[:key],
        filename: row[:filename],
        content_type: row[:content_type],
        metadata: row[:metadata],
        service_name: row[:service_name],
        byte_size: row[:byte_size],
        checksum: row[:checksum],
        created_at: row[:created_at],
      }]
    )
  end
end

def create_attachments
  DB.fetch("select * from active_storage_attachments") do |row|
    if row[:record_type] != "ActiveStorage.VariantRecord"
      t = ActiveStorage::Attachment.insert_all([
        {
          id: row[:id],
          name: row[:name],
          record_id: row[:record_id],
          record_type: row[:record_type],
          blob_id: row[:blob_id],
          created_at: row[:created_at]
        }
      ])
    end
  end
end

namespace :importer do

  task load: :environment do
    # create_users
    # create_oauth_credentials
    # create_follows
    # create_tracks
    # create_playlists
    # track_playlists
    # create_reposts
    # track_comments
    track_likes
    # create_categories
    # create_posts
    # create_events
    # event_recordings
    # event_tickets
    # event_hosts
    # listening_events
    ## preview_cards
    ## event_purchase_orders

    # create_blobs
    # create_attachments

  end


  task checksums: :environment do

    ActiveStorage::Blob.where("content_type LIKE ?", "image/%").where("id >= ?", 438).find_each do |b|
      puts "processing #{b.id}"
      path = Rails.root.join('tmp/kk', b.key)

      begin
        b.download do |chunk|
          File.open(path, 'ab') { |file| file.write(chunk) }
        end

        b.checksum = b.send(:compute_checksum_in_chunks, File.open(path))
        b.save

        File.delete(path) 
        puts "processed #{b.id}"
      rescue => e
        puts "Fails #{b.id}"
      end
    end
  end
end




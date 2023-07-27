class CreateListeningEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :listening_events do |t|
      t.string :remote_ip
      t.string :country
      t.string :city
      t.string :ua
      t.string :lang
      t.string :referer
      t.string :utm_medium
      t.string :utm_source
      t.string :utm_campaign
      t.string :utm_content
      t.string :utm_term
      t.string :browser_name
      t.string :browser_version
      t.string :modern
      t.string :platform
      t.string :device_type
      t.boolean :bot
      t.boolean :search_engine
      t.integer :resource_profile_id
      t.integer :user_id
      t.integer :track_id
      t.integer :playlist_id

      t.timestamps
    end
  end
end

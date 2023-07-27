class CreateOauthCredentials < ActiveRecord::Migration[7.0]
  def change
    create_table :oauth_credentials do |t|
      t.string :uid
      t.string :token
      t.jsonb :data
      t.string :provider
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

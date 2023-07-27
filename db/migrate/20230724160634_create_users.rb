class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.boolean :label
      t.string :support_link
      t.string :first_name
      t.string :last_name
      t.string :country
      t.string :city
      t.text :bio
      t.jsonb :settings
      t.string :role

      t.timestamps
    end
  end
end

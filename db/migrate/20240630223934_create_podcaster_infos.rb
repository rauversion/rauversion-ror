class CreatePodcasterInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :podcaster_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.text :title
      t.text :about

      t.timestamps
    end
  end
end

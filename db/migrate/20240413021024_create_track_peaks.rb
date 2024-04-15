class CreateTrackPeaks < ActiveRecord::Migration[7.0]
  def change
    create_table :track_peaks do |t|
      t.references :track, null: false, foreign_key: true
      t.jsonb :data

      t.timestamps
    end
  end
end

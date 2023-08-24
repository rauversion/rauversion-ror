class ChangeLatlngOnEvent < ActiveRecord::Migration[7.0]
  def up
    change_column :events, :lat, :decimal, :precision => 10, :scale => 6
    change_column :events, :lng, :decimal, :precision => 10, :scale => 6
  end

  def down
    change_column :events, :lat, :integer
    change_column :events, :lng, :integer
  end
end

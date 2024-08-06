class AddDataToPodcasterInfos < ActiveRecord::Migration[7.1]
  def change
    add_column :podcaster_infos, :data, :jsonb
  end
end

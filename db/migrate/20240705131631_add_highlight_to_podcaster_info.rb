class AddHighlightToPodcasterInfo < ActiveRecord::Migration[7.1]
  def change
    add_column :podcaster_infos, :settings, :jsonb
    add_column :podcaster_infos, :highlight, :boolean
  end
end

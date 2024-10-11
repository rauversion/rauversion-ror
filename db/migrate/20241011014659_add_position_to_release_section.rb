class AddPositionToReleaseSection < ActiveRecord::Migration[7.2]
  def change
    add_column :release_sections, :position, :integer
  end
end

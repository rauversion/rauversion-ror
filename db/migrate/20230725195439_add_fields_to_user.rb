class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notification_settings, :jsonb
    # add_column :users, :settings, :jsonb
  end
end

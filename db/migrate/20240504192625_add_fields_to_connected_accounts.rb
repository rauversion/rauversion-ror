class AddFieldsToConnectedAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :connected_accounts, :password, :string
  end
end

class CreateConnectedAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :connected_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :state
      t.references :parent, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end

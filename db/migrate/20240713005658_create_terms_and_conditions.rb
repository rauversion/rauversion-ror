class CreateTermsAndConditions < ActiveRecord::Migration[7.1]
  def change
    create_table :terms_and_conditions do |t|
      t.string :title
      t.string :category
      t.text :content

      t.timestamps
    end
  end
end

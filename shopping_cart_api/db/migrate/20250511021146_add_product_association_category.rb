class AddProductAssociationCategory < ActiveRecord::Migration[8.0]
  def change
    change_table :products do |t|
      t.references :category, foreign_key: { to_table: :categories}, null: false
    end
  end
end

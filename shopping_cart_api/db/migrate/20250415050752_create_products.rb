class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :product_name, null: false
      t.string :thumbnail, null: false
      t.integer :quantity, null: false, default: 0
      t.decimal :price, null: false, precision: 15, scale: 2, default: 0
      t.references :unit, foreign_key: { to_table: :units }, null: false
      t.timestamps
    end
    add_check_constraint :products, 'quantity >= 0', name: 'check_products_quantity_positive'
    add_check_constraint :products, 'price >= 0', name: 'check_products_price_positive'
  end
end

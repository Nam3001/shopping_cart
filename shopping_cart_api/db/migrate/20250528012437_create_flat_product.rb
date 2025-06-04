class CreateFlatProduct < ActiveRecord::Migration[8.0]
  def change
    create_table :flat_products do |t|
      t.bigint :product_id, null: false
      t.string :product_name, null: false
      t.integer :quantity, null: false, default: 0
      t.decimal :price, precision: 15, scale: 2, default: 0.0, null: false
      t.decimal :old_price, precision: 15, scale: 2, default: 0.0, null: false
      t.string :sku, null: true
      t.text :attributes, null: true
      t.text :attribute_values, null: true
      t.timestamps
    end

    add_index :flat_products, :product_name
    add_index :flat_products, [:product_name, :sku]
  end
end

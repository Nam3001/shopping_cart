class CreateProductVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variants do |t|
      t.references :product, foreign_key: { to_table: :products }, null: false
      t.integer :quantity, null: false, default: 0
      t.decimal :price, null: false, precision: 15, scale: 2, default: 0
      t.decimal :old_price, precision: 15, scale: 2, default: 0
      t.string :sku, null: false
      t.timestamps
    end
  end
end

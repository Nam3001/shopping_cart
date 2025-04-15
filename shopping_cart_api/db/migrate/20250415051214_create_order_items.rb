class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items, id: false do |t|
      t.bigint :order_id, null: false
      t.bigint :product_id, null: false
      t.integer :quantity, null: false, default: 1
      t.decimal :price, null: false, default: 0, precision: 15, scale: 2
      t.decimal :promotion, null: false, default: 0, precision: 5, scale: 2
      t.timestamps

      t.primary_key [:order_id, :product_id]
      t.foreign_key :orders, column: :order_id, primary_key: :id, null: false, foreign_key: true, on_delete: :restrict
      t.foreign_key :products, column: :product_id, primary_key: :id, null: false, foreign_key: true, on_delete: :restrict
    end

    add_check_constraint :order_items, 'quantity > 0', name: 'check_order_items_quantity_positive'
    add_check_constraint :order_items, 'price >= 0', name: 'check_order_items_price_positive'
    add_check_constraint :order_items, 'promotion >= 0 and promotion <= 100', name: 'check_order_items_promotion_valid'
  end
end

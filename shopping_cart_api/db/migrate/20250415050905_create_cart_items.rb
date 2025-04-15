class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.bigint :user_id, null: false
      t.bigint :product_id, null: false
      t.integer :quantity, null: false, default: 1
      t.timestamps

      t.foreign_key :users, column: :user_id, primary_key: :id, null: false, foreign_key: true, on_delete: :restrict
      t.foreign_key :products, column: :product_id, primary_key: :id, null: false, foreign_key: true, on_delete: :restrict
    end

    add_check_constraint :cart_items, 'quantity > 0 ', name: 'check_cart_items_quantity_positive'

  end
end

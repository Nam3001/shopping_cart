class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :status, null: false, default: 0
      t.timestamps
      
      t.references :user, null: false, foreign_key: { to_table: :users }, index: true
    end
  end
end

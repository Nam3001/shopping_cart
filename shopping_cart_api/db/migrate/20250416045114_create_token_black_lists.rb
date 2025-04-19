class CreateTokenBlackLists < ActiveRecord::Migration[8.0]
  def change
    create_table :token_black_lists do |t|
      t.string :jti
      t.datetime :exp

      t.timestamps
    end
    add_index :token_black_lists, :jti
  end
end

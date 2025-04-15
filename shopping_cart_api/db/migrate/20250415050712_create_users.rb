class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :address, null: false
      t.string :email_address, null: false
      t.string :fullname, null: false
      t.integer :role, null: false, default: 0
      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email_address, unique: true
  end
end

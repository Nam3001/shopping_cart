class CreateUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :units do |t|
      t.string :unit_name, null: false
      t.string :unit_description, null: false
      t.timestamps
    end
    
    add_index :units, :unit_name, unique: true
  end
end

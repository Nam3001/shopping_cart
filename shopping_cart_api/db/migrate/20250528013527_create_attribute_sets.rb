class CreateAttributeSets < ActiveRecord::Migration[8.0]
  def change
    create_table :attribute_sets do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :attribute_sets, :name, unique: true
  end
end

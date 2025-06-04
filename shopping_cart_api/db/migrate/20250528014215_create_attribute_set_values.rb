class CreateAttributeSetValues < ActiveRecord::Migration[8.0]
  def change
    create_table :attribute_set_values do |t|
      t.references :attribute_set, foreign_key: { to_table: :attribute_sets }, null: false
      t.references :attribute, foreign_key: { to_table: :attributes }, null: false
      t.references :attribute_value, foreign_key: { to_table: :attribute_values }, null: false
      t.timestamps
    end

  end
end

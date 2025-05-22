class CreateAttributeIndexing < ActiveRecord::Migration[8.0]
  def change
    add_index :attribute_values, [:value, :attribute_id], unique: true, name: 'index_attribute_values_on_value_and_attribute_id'

    add_index :attributes, :name, unique: true
  end
end

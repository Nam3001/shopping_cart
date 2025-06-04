class AddUniqueIndexToAttributeValue < ActiveRecord::Migration[8.0]
  def change
    add_index :attribute_values, :value, unique: true
  end
end

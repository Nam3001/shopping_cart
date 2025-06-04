class DropProductAttributeValuesTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :product_attribute_values
  end
end

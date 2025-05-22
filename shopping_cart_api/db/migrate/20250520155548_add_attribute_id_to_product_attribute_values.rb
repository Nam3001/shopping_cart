class AddAttributeIdToProductAttributeValues < ActiveRecord::Migration[8.0]
  def change
    add_column :product_attribute_values, :attribute_id, :bigint
  end
end

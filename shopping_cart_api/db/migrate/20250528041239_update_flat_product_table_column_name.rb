class UpdateFlatProductTableColumnName < ActiveRecord::Migration[8.0]
  def change
    rename_column :flat_products, :attribute_values, :variant_values
  end
end

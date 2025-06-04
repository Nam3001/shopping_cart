class UpdateFlatProductTableDropColumnProductName < ActiveRecord::Migration[8.0]
  def change
    remove_column :flat_products, :product_name
    remove_column :flat_products, :product_attributes
     add_foreign_key :flat_products, :products
  end
end

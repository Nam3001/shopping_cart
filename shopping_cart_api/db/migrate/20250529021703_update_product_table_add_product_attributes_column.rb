class UpdateProductTableAddProductAttributesColumn < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :product_attributes, :text, null: true
  end
end

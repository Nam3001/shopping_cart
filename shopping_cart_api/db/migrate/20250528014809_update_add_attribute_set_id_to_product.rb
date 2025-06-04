class UpdateAddAttributeSetIdToProduct < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :attribute_set, foreign_key: true, null: true
  end
end

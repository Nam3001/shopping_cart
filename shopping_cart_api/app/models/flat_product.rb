class FlatProduct < ApplicationRecord
  validates :product_id, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  validates :old_price, presence: true
  validates :sku, presence: true
  validates :variant_values, presence: true

  belongs_to :product
end
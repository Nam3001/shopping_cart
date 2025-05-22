class ProductVariant < ApplicationRecord
  belongs_to :product

  validates :quantity, presence: true
  validates :price, presence: true
  validates :product_id, presence: true
end

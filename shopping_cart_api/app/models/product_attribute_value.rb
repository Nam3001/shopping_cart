class ProductAttributeValue < ApplicationRecord
  belongs_to :attribute_value, foreign_key: 'attribute_value_id', class_name: 'AttributeValue'
  belongs_to :product



  validates :product_id, presence: true
  validates :attribute_value_id, presence: true
end
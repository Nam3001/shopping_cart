class AttributeValue < ApplicationRecord
  belongs_to :product_attribute, foreign_key: 'attribute_id', class_name: 'ProductAttribute'
  belongs_to :product_attribute_value, foreign_key: 'attribute_value_id', class_name: 'ProductAttributeValue'

  validates :value, presence: true
  validates :attribute_id, presence: true
end

class AttributeValue < ApplicationRecord
  belongs_to :product_attribute, foreign_key: 'attribute_id', class_name: 'ProductAttribute'
  has_many :product_attribute_values, class_name: 'ProductAttributeValue'

  validates :value, presence: true
  validates :attribute_id, presence: true
end

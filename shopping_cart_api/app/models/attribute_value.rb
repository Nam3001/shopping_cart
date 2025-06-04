class AttributeValue < ApplicationRecord
  belongs_to :product_attribute, foreign_key: 'attribute_id', class_name: 'ProductAttribute'

  validates :value, presence: true
  validates :attribute_id, presence: true
end

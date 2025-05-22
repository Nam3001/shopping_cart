class ProductAttribute < ApplicationRecord
  has_many :attribute_values, foreign_key: 'attribute_id', dependent: :destroy

  validates :name, presence: true

  self.table_name = "attributes"
end

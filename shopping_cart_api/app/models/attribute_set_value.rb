class AttributeSetValue < ApplicationRecord
  validates :attribute_id, presence: true
  validates :attribute_set_id, presence: true
  validates :attribute_value_id, presence: true
end
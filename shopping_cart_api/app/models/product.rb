class Product < ApplicationRecord
    has_many :cart_items 
    has_many :users
    belongs_to :unit
    
    validates :product_name, presence: true
    validates :price, presence: true, comparison: { greater_than_or_equal_to: 0 }
    validates :thumbnail, presence: true
    validates :quantity, presence: true, comparison: { greater_than_or_equal_to: 0 }
end

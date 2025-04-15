class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product

    validates :quantity, presence: true, comparison: { greater_than: 0 }
    validates :price, presence: true, comparison: { greater_than_or_equal_to: 0 }
    validates :promotion, presence: true, comparison: { less_than_or_equal_to: 100 }
end

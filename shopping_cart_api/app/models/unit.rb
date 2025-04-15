class Unit < ApplicationRecord
    has_many :products

    validates :unit_name, presence: true
end

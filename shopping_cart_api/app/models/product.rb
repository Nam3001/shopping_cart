class Product < ApplicationRecord
    belongs_to :unit
    has_one_attached :thumbnail
    
    validates :product_name, presence: true
    validates :price, presence: true, comparison: { greater_than_or_equal_to: 0 }
    validates :thumbnail, presence: true
    validates :quantity, presence: true, comparison: { greater_than_or_equal_to: 0 }
    validates_comparison_of :quantity, greater_than_or_equal_to: 0

    validate :acceptable_thumbnail

    private
    def acceptable_thumbnail
        return unless thumbnail.attached?

        if thumbnail.byte_size > 1.megabyte
            errors.add(:thumbnail, "is too big (max 1MB)")
        end

        unless thumbnail.content_type.start_with?('image/')
            errors.add(:thumbnail, "image must be JPG or PNG")
        end
    end
end

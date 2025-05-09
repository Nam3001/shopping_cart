class Product < ApplicationRecord
    after_destroy :handle_caching_after_destroy_product
    after_create :handle_caching_after_create_product
    after_update :handle_caching_after_update_product

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

    def delete_product_pagination_cache
      RedisHelper.delete_pagination_cache("products/all")
    end

    def handle_caching_after_create_product
      delete_product_pagination_cache
    end

    def handle_caching_after_destroy_product
      delete_product_pagination_cache

      # delete deleted product information
      cache_key = "product/#{id}"
      RedisHelper.delete_cache(cache_key)
    end

    def handle_caching_after_update_product
      delete_product_pagination_cache

      cache_key = "product/#{id}"
      RedisHelper.update_cache(cache_key, self)
    end
end

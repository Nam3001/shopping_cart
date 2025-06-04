require 'sanitize'

class Product < ApplicationRecord
    after_destroy :handle_caching_after_destroy_product
    after_create :handle_caching_after_create_product
    after_update :handle_caching_after_update_product

    belongs_to :unit
    belongs_to :category
    has_many_attached :thumbnails


    has_many :product_variants, dependent: :destroy
    has_many :flat_products, dependent: :destroy

    validates :product_name, presence: true
    validates :price, presence: true, comparison: { greater_than_or_equal_to: 0 }
    validates :thumbnails, presence: true
    validates :quantity, presence: true, comparison: { greater_than_or_equal_to: 0 }
    validates_comparison_of :quantity, greater_than_or_equal_to: 0
    validates :unit_id, presence: true
    validates :category_id, presence: true
    validates :description, presence: true

    validate :acceptable_thumbnails


    private
    def acceptable_thumbnails
      return unless thumbnails.attached?
      thumbnails.each do |thumbnail|
        if thumbnail.byte_size > 1.megabyte
            errors.add(:thumbnail, "is too big (max 1MB)")
        end

        unless thumbnail.content_type.start_with?('image/')
            errors.add(:thumbnail, "image must be JPG or PNG")
        end
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
      
      # delete list of products of category cache
      RedisHelper.delete_pagination_cache("category/#{category_id}/products/all")

      cache_key = "product/#{id}"
      RedisHelper.update_cache(cache_key, self)
    end

    def sanitize_description
      self.description = Sanitize.fragment(description, Sanitize::Config::RELAXED)
    end
end

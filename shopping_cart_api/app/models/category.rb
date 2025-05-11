class Category < ApplicationRecord
  after_destroy :handle_caching_after_destroy_category
  after_update :handle_caching_after_update_category
  after_create :handle_caching_after_create_category

  has_many :products

  validates :name, presence: true

  private
  def delete_category_pagination_cache
    RedisHelper.delete_pagination_cache("categories/all")
  end

  def handle_caching_after_create_category
    delete_category_pagination_cache
  end

  def handle_caching_after_destroy_category
    delete_category_pagination_cache

    # delete deleted category information
    cache_key = "category/#{id}"
    RedisHelper.delete_cache(cache_key)
  end

  def handle_caching_after_update_category
    delete_category_pagination_cache

    cache_key = "category/#{id}"
    RedisHelper.update_cache(cache_key, self)
  end
end

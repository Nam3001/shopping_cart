class Unit < ApplicationRecord
  after_destroy :handle_caching_after_destroy_unit
  after_update :handle_caching_after_update_unit
  after_create :handle_caching_after_create_unit

  has_many :products

  validates :unit_name, presence: true

  private
  def delete_unit_pagination_cache
    RedisHelper.delete_pagination_cache("units/all")
  end

  def handle_caching_after_create_unit
    delete_unit_pagination_cache
  end

  def handle_caching_after_destroy_unit
    delete_unit_pagination_cache

    # delete deleted unit information
    cache_key = "unit/#{id}"
    RedisHelper.delete_cache(cache_key)
  end

  def handle_caching_after_update_unit
    delete_unit_pagination_cache

    cache_key = "unit/#{id}"
    RedisHelper.update_cache(cache_key, self)
  end
end

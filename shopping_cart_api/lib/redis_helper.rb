class RedisHelper
  class << self
    def delete_pagination_cache(pattern)
      $redis.keys("#{ENV['REDIS_NAMESPACE']}:#{pattern}/*").each do |key|
        $redis.del key
      end
    end

    def update_cache(cache_key, value)
      Rails.cache.write(cache_key, value)
    end

    def delete_cache(cache_key)
      Rails.cache.delete(cache_key)
    end
  end
end
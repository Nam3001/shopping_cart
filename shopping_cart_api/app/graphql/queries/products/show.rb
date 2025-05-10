class Queries::Products::Show < Queries::BaseQuery
  argument :id, ID, required: true
  type Types::ProductType, null: true

  def resolve(id:)
    begin
      cache_key = "product/#{id}"
      
      Rails.cache.fetch(cache_key) do
        Product.find(id)
      end
    rescue ActiveRecord::RecordNotFound
      raise GraphQL::ExecutionError, "Product #{id} not found"
    rescue => e
      raise GraphQL::ExecutionError, "An error occur: #{e.message}"
    end
  end
end
class Queries::Products::GetAll < Queries::BaseQuery
  argument :page, GraphQL::Types::Int, required: false, default_value: 1
  argument :per_page, GraphQL::Types::Int, required: false, default_value: 10
  type Types::ProductConnectionType, null: false


  def resolve(page:, per_page:)
    products = Rails.cache.fetch("products/all/graphql/page=#{page}/per_page=#{per_page}") do
      paginatedProduct = Product.with_attached_thumbnail.order(updated_at: :desc).page(page).per(per_page)
      {
        products: ActiveModelSerializers::SerializableResource.new(paginatedProduct, each_serializer: ProductSerializer).as_json,
        pagination: {
          current_page: paginatedProduct.current_page,
          total_pages: paginatedProduct.total_pages,
          total_count: paginatedProduct.total_count
        }
      }
    end

    products
  end
end
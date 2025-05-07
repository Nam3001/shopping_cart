class Queries::Products::GetAll < Queries::BaseQuery
  argument :page, GraphQL::Types::Int, required: false, default_value: 1
  argument :per_page, GraphQL::Types::Int, required: false, default_value: 10
  type Types::ProductConnectionType, null: false

  def resolve(page:, per_page:)
    products = Product.with_attached_thumbnail.page(page).per(per_page)
    
    {
      products: products,
      pagination: {
        current_page: products.current_page,
        total_pages: products.total_pages,
        total_count: products.total_count
      }
    }
  end
end
module ProductService
  class GetAll < ApplicationService
    def initialize(params)
      @params = params
    end

    @@products_cache_key = "products/all"

    def call
      begin
        page = @params[:page]
        per_page = @params[:per_page]

        products = Rails.cache.fetch("#{@@products_cache_key}/page=#{page}/per_page=#{per_page}") do
          paginatedProduct = Product.includes(:category, :unit, :flat_products).with_attached_thumbnails.page(page).per(per_page).order(updated_at: :desc)
          {
            products: ActiveModelSerializers::SerializableResource.new(paginatedProduct, each_serializer: ProductSerializer).as_json,
            pagination: {
              current_page: paginatedProduct.current_page,
              total_pages: paginatedProduct.total_pages,
              total_count: paginatedProduct.total_count
            }
          }
        end

        {
          error: nil,
          products:
        }
      rescue => e
        {
          error: e.message,
          products: nil
        }
      end
    end
  end
end
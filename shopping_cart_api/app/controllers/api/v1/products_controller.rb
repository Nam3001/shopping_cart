class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :set_product, only: [:show, :update, :destroy]

  @@products_cache_key = "products/all"
  @@detail_product_cache_key = "product"

  def index
    authorize Product, policy_class: ProductPolicy
    begin
      page = params[:page]
      per_page = params[:per_page]

      products = Rails.cache.fetch("#{@@products_cache_key}/page=#{page}/per_page=#{per_page}") do
        paginatedProduct = Product.includes(:category, :unit).with_attached_thumbnail.page(page).per(per_page).order(updated_at: :desc)
        {
          products: ActiveModelSerializers::SerializableResource.new(paginatedProduct, each_serializer: ProductSerializer).as_json,
          pagination: {
            current_page: paginatedProduct.current_page,
            total_pages: paginatedProduct.total_pages,
            total_count: paginatedProduct.total_count
          }
        }
      end

      render json: products, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
    
  end

  def show
    authorize @product
    render json: @product, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def create
    product = Product.new(product_params)
    authorize product
    if product.save
      
      render json: product, status: :created
    else
      render json: { error: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @product
    isUpdateSuccess = @product.update(product_params)
    if(isUpdateSuccess)
      render json: @product, status: :ok
    else
      render json: { error: @product.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e 
      render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    authorize @product
    @product.destroy!


    head :no_content
  rescue ActiveRecord::InvalidForeignKey
    render json: { error: "This product can not be deleted, because there are any order or cart has this product" }, status: :unprocessable_entity
  rescue ActiveRecord::RecodeNotFound
    render json: { error: 'Product not found' }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def product_params
    params.permit(:product_name, :quantity, :price, :unit_id, :category_id, :thumbnail, :description)
  end

  private

  def set_product
    begin
      cache_key = "#{@@detail_product_cache_key}/#{params[:id]}"
      @product = Rails.cache.fetch(cache_key) do
        Product.find(params[:id])
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end

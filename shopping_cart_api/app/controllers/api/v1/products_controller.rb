class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :set_product, only: [:show, :update, :destroy]

  @@products_cache_key = "products/all/v1"
  @@detail_product_cache_key = "product/v1"

  def index
    page = params[:page]
    per_page = params[:per_page] || 10
    products = Rails.cache.fetch("products/all/v1/page=#{page}/per_page=#{per_page}") do
      # Product.with_attached_thumbnail.order(created_at: :desc).page(page).per(per_page)
      # Product.order(created_at: :desc).page(page).per(per_page)
      Product.page(1).per(1).map(&:attributes) 
    end

    authorize products
    render json: {
      data: products.map { |p| product_json p},
      pagination: {
        # current_page: products.current_page,
        # total_pages: products.total_pages,
        # total_count: products.total_count
        current_page: 1,
        total_pages: 2,
        total_count: 1
      }
    }, status: :ok
  end

  def show
    authorize @product
    render json: product_json(@product)
  rescue ActiveRecord::RecodeNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def create
    product = Product.new(product_params)
    authorize product

    
    if product.save
      delete_pagination_products_cache
      render json: product_json(product), status: :created
    else
      render json: { error: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @product
    if(@product.update(product_params))
      delete_pagination_products_cache
      render json: product_json(@product), status: :ok
    else
      render json: { error: @product.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecodeNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def destroy
    authorize @product
    @product.destroy?

    delete_pagination_products_cache

    head :no_content
  rescue ActiveRecord::InvalidForeignKey
    render json: { error: "This product can not be deleted, because there are any order or cart has this product" }, status: :unprocessable_entity
  rescue ActiveRecord::RecodeNotFound
    render json: { error: 'Product not found' }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def product_params
    params.permit(:product_name, :quantity, :price, :unit_id, :thumbnail)
  end

  private
  def product_json(product)
    product.as_json.merge(thumbnail_url: product.thumbnail.attached? ? url_for(product.thumbnail) : "")
  end

  def set_product
    cache_key = "#{@@detail_product_cache_key}/#{params[:id]}"
    @product = Rails.cache.fetch(cache_key) do
      Product.find(params[:id])
    end
  end

  def delete_pagination_products_cache
    Rails.cache.delete_matched("#{@@detail_product_cache_key}/page=*")
  end
end

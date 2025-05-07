class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :set_product, only: [:show, :update, :destroy]

  def index
    page = params[:page]
    per_page = params[:per_page] || 10
    products = Product.with_attached_thumbnail.page(page).per(per_page)
    authorize products
    render json: {
      data: products.map { |p| product_json p},
      pagination: {
        current_page: products.current_page,
        total_pages: products.total_pages,
        total_count: products.total_count
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
      render json: product_json(product), status: :created
    else
      render json: { error: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @product
    if(@product.update(product_params))
      render json: product_json(@product), status: :ok
    else
      render json: { error: @product.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecodeNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def destroy
    authorize @product
    @product.destroy
    head :no_content
  rescue ActiveRecord::InvalidForeignKey
    render json: { error: "This product can not be deleted, because there are any order or cart has this product" }, status: :unprocessable_entity
  rescue ActiveRecord::RecodeNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def product_params
    params.permit(:product_name, :quantity, :price, :unit_id, :thumbnail)
  end

  private
  def product_json(product)
    product.as_json.merge(thumbnail_url: product.thumbnail.attached? ? url_for(product.thumbnail) : "")
  end

  def set_product
    @product = product = Product.find(params[:id])
  end
end

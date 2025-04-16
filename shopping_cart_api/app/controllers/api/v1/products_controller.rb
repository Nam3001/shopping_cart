class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  before_action :set_product, only: [:show, :update, :destroy]

  def index 
    products = Product.all.with_attached_thumbnail
    authorize products
    render json: products.map { |p| product_json p}, status: :ok
  end

  def show
    # product = Product.find(params[:id])
    authorize @product
    render json: product_json(@product)
  end

  def create
    product = Product.new(product_params)
    if product.save
      render json: product_json(product), status: :created
    else
      render json: { error: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # product = Product.find(params[:id])
    if(@product.update(product_params))
      render json: product_json(@product), status: :ok
    else
      render json: { error: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    # product = Product.find(params[:id])
    @product.destroy
    head :no_content
  rescue ActiveRecord::InvalidForeignKey
    render json: { error: "This product can not be deleted, because there are any order or cart has this product" }, status: :unprocessable_entity
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

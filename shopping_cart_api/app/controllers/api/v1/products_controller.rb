class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :set_product, only: [:show, :update, :destroy]

  def index
    authorize Product
    result = ProductService::GetAll.call(params)
    if result[:error].nil?
      render json: result[:products], status: :ok
    else
      render json: { error: result[:error] }, status: :internal_server_error
    end
  end

  def show
    authorize @product
    render json: @product, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def create
    authorize Product
    result = ProductService::CreateProduct.call(params)
    product = result[:product]
    error = result[:error]
    
    if error.nil?
      render json: product, status: :created
    else
      render json: { error: error }, status: :unprocessable_entity
    end
  end

  def update
    authorize @product
    
    result = ProductService::Update.call(params, @product)
    unless result[:error].nil?
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: @product, status: :ok
    end
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

  private
  def set_product
    begin
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end

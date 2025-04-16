class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  def index 
    @products = Product.all
    authorize @products
    render json: @products, status: :ok
  end

  def show
    product = Product.find(params[:id])
    authorize product
    render json: product, status: :ok
  end
end

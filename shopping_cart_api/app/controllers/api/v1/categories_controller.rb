class Api::V1::CategoriesController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show, :products]
  before_action :set_category, only: [:show, :destroy, :update]

  @@categories_cache_key = "categories/all"
  @@detail_category_cache_key = "category"

  def index
    begin
      page = params[:page]
      per_page = params[:per_page]
      respondData = nil
      
      if page && per_page
        respondData = Rails.cache.fetch("#{@@categories_cache_key}/page=#{page}/per_page=#{per_page}") do
          paginated = Category.page(page).per(per_page).order(updated_at: :desc)
          {
            categories: paginated.as_json,
            pagination: {
              current_page: paginated.current_page,
              total_pages: paginated.total_pages,
              total_count: paginated.total_count
            }
          }
        end
      else
        respondData = Rails.cache.fetch("#{@@categories_cache_key}") do
          paginated = Category.order(updated_at: :desc)
          {
            categories: paginated.as_json
          }
        end
      end
      render json: respondData, status: :ok
    rescue => e 
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def show 
    begin
      render json: @category, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Not found category!"}, status: :not_found
    rescue => e 
      render json: { error: e.message }, status: :internal_server_error
    end
    
  end

  def create
    authorize Category
    begin
      cate = Category.new(category_params)
      if cate.save!
        render json: cate, status: :created
      else
        render json: { errors: cate.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: [e.message] }, status: :unprocessable_entity
    end
    
  end

  def update
    authorize Category
    begin
      if @category.update(category_params)
        render json: @category, status: :ok
      else
        render json: { error: "Update category fail" }, status: :unprocessable_entity
      end
    rescue => e 
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def destroy 
    authorize Category
    begin
      @category.destroy!

      head :no_content
    rescue ActiveRecord::InvalidForeignKey
      render json: { error: "This category can not be deleted, because there are any items depend on this category" }, status: :unprocessable_entity
    rescue ActiveRecord::RecodeNotFound
      render json: { error: 'Category not found' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def products
    begin
      page = params[:page] || 1
      per_page = params[:per_page] || 10
      respondData = Rails.cache.fetch("#{@@detail_category_cache_key}/#{params[:id]}/products/all/page=#{page}/per_page=#{per_page}") do
        paginated = Product.where(category_id: params[:id]).with_attached_thumbnails.page(page).per(per_page).order(updated_at: :desc)
        {
          products: ActiveModelSerializers::SerializableResource.new(paginated, each_serializer: ProductSerializer).as_json,
          pagination: {
            current_page: paginated.current_page,
            total_pages: paginated.total_pages,
            total_count: paginated.total_count
          }
        }
      end
      render json: respondData, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def set_category
    begin
      @category = Rails.cache.fetch("#{@@detail_category_cache_key}/#{params[:id]}") do
      Category.find params[:id]
    end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def category_params
    params.permit(:name)
  end
end

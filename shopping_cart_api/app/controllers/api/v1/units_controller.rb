class Api::V1::UnitsController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show]
  before_action :set_unit, only: [:show, :destroy, :update]

  @@units_cache_key = "units/all"
  @@detail_unit_cache_key = "unit"

  def index
    begin
      page = params[:page]
      per_page = params[:per_page]
      respondData = nil
      
      if page && per_page
        respondData = Rails.cache.fetch("#{@@units_cache_key}/page=#{page}/per_page=#{per_page}") do
          paginated = Unit.page(page).per(per_page).order(updated_at: :desc)
          {
            units: paginated.as_json,
            pagination: {
              current_page: paginated.current_page,
              total_pages: paginated.total_pages,
              total_count: paginated.total_count
            }
          }
        end
      else
        respondData = Rails.cache.fetch("#{@@units_cache_key}/page=#{page}/per_page=#{per_page}") do
          paginated = Unit.order(updated_at: :desc)
          {
            units: paginated.as_json,
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
      render json: @unit, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Unit not found"}, status: :not_found
    rescue => e 
      render json: { error: e.message }, status: :internal_server_error
    end
    
  end

  def create
    authorize Unit
    begin
      unit = Unit.new(unit_params)
      if unit.save!
        render json: unit, status: :created
      else
        render json: { errors: unit.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: [e.message] }, status: :unprocessable_entity
    end
    
  end

  def update
    authorize Unit
    begin
      if @unit.update(unit_params)
        render json: @unit, status: :ok
      else
        render json: { error: "Update unit fail" }, status: :unprocessable_entity
      end
    rescue => e 
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def destroy 
    authorize Unit
    begin
      @unit.destroy!

      head :no_content
    rescue ActiveRecord::InvalidForeignKey
      render json: { error: "This unit can not be deleted, because there are any items depend on this unit" }, status: :unprocessable_entity
    rescue ActiveRecord::RecodeNotFound
      render json: { error: 'Unit not found' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def set_unit
    begin
      @unit = Rails.cache.fetch("#{@@detail_unit_cache_key}/#{params[:id]}") do
      Unit.find params[:id]
    end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def unit_params
    params.permit(:unit_name)
  end
end

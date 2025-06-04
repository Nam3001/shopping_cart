class Api::V1::AttributesController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show]
  before_action :set_product_attribute, only: [:show, :update]

  def index
    is_get_all = params[:page].nil? && params[:per_page].nil?
    response = {}
    if is_get_all
      attributes = ProductAttribute.all
      response = {
        attributes: ActiveModelSerializers::SerializableResource.new(attributes, each_serializer: ProductAttributeSerializer).as_json,
      }
    else
      attributes = ProductAttribute.page(params[:page] || 1).per(params[:per_page] || 10)
      response = {
        attributes: ActiveModelSerializers::SerializableResource.new(attributes, each_serializer: ProductAttributeSerializer).as_json,
        pagination: {
          current_page: attributes.current_page,
          total_pages: attributes.total_pages,
          total_count: attributes.total_count
        }
      }
    end
    
    render json: response, status: :ok
  end

  def show
    render json: @attribute, serializer: ProductAttributeSerializer, status: :ok
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        attr = ProductAttribute.new(name: params[:name])

        isSuccess = attr.save
        
        if isSuccess
          values = params[:values] || []
          unless values.empty?
            begin
              attr.attribute_values.create! values.map { |value| { value: value } }
            rescue => e
              raise ActiveRecord::Rollback, e.message
            end
          end
        else
          raise ActiveRecord::Rollback
          return
        end

        render json: attr, serializer: ProductAttributeSerializer, status: :created
        return
      rescue => e
        raise e.message
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
      return
    end
  end

  def update
    ActiveRecord::Base.transaction do
      values = params[:values] || []
      begin
        attribute_values_to_delete = @attribute.attribute_values.where(id: params[:values_to_delete]).includes(:product_attribute_values)
        delete_attribute_value attribute_values_to_delete unless attribute_values_to_delete.empty? || attribute_values_to_delete.nil? 
        
        values.each do |value|
          value_id = value[:id]
          value_value = value[:value]
          
          unless value_value.present?
            next
          end
          
          if (!value_id.nil? && !params[:values_to_delete]) || (!value_id.nil? && !params[:values_to_delete]&.include?(value_id))
            old_value = @attribute.attribute_values.find_by(id: value_id)
            if old_value
              old_value.update(value: value_value)
            end
          elsif (value_value.present? && @attribute.attribute_values.find_by(value: value_value).nil?)
            @attribute.attribute_values.create(value: value_value)
          end
        end

        if params[:name].present?
          @attribute.update!(name: params[:name])
        end
      rescue => e
        raise ActiveRecord::Rollback, e.message
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
      return
    end

    render json: @attribute, serializer: ProductAttributeSerializer, status: :ok
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        attribute = ProductAttribute.includes(attribute_values: :product_attribute_values).find(params[:id])
        delete_attribute_value attribute.attribute_values
        

        attribute.destroy!
        render json: { message: 'Attribute deleted successfully' }, status: :ok
      rescue => e
        raise ActiveRecord::Rollback, e.message
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private
  def delete_attribute_value(attribute_values_to_delete)
    attribute_values_to_delete.each do |attribute_value|
      attribute_value.product_attribute_values.each do |product_attribute_value|
        product_id = product_attribute_value.product_id

        ProductVariant.where(product_id: product_id).each do |product_variant|
          old_sku = product_variant.sku
          new_sku = old_sku.split('-').reject { |sku| sku == attribute_value.id.to_s }.join('-')
          product_variant.update! sku: new_sku
        end

        product_attribute_value.destroy!
      end
      attribute_value.destroy!
    end
  end

  def set_product_attribute
    @attribute = ProductAttribute.find(params[:id])
  end
end

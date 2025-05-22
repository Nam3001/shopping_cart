class Api::V1::AttributesController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show]
  before_action :set_product_attribute, only: [:show, :update]

  def index
    attributes = ProductAttribute.all
    render json: attributes, each_serializer: ProductAttributeSerializer, status: :ok
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
    if @attribute.update(name: params[:name])
      ActiveRecord::Base.transaction do
        values = params[:values] || []
        begin
          unless params[:values_to_delete].nil?
            params[:values_to_delete].each do |value_id|
              @attribute.attribute_values.find_by(id: value_id)&.destroy!
            end
          end

          values.each do |value|
          value_id = value[:id]
          value_value = value[:value]

          unless value_value.present?
            next
          end

          if !value_id.nil? && !params[:values_to_delete].include?(value_id)
            old_value = @attribute.attribute_values.find_by(id: value_id)
            if old_value
              old_value.update(value: value_value)
            end
          elsif (value_value.present? && @attribute.attribute_values.find_by(value: value_value).nil?)
            @attribute.attribute_values.create(value: value_value)
          end
        end
        rescue => e
          raise ActiveRecord::Rollback, e.message
        end
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      render json: @attribute, serializer: ProductAttributeSerializer, status: :ok
    else
      render json: { error: @attribute.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_product_attribute
    @attribute = ProductAttribute.find(params[:id])
  end
end

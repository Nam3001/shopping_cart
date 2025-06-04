module ProductService
  class CreateProduct < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      begin
        @product_params = product_params
        product = Product.new(@product_params)
        @variant_params = variant_params
        
        ActiveRecord::Base.transaction do
          isCreateSuccess = product.save
          raise ActiveRecord::Rollback, product.errors.full_messages unless isCreateSuccess
          
          attributes = @variant_params[:attributes]
          product_variants = @variant_params[:product_variants]

          product_attributes = []
          attribute_value_list = []
          attributes&.values&.each do |attribute|
            name = attribute[:name]
            
            if product_attributes&.include? name
              next
            end
            
            values = attribute[:values]&.uniq
            
            attribute_found = ProductAttribute.includes(:attribute_values).find_by(name:)
            attribute_values = attribute_found.attribute_values.where(value: values)
            if !attribute_found.nil? && attribute_values.length > 0
              product_attributes.push(
                {
                  id: attribute_found.id,
                  name: attribute_found.name,
                  values:
                }
                )
                attribute_value_list.push(*attribute_values)
            end
          end

          product.update! product_attributes: product_attributes.to_json
          
          product_variants&.values&.each do |product_variant|
            # values of dupplicate attribute => cannot insert (this hasn't been solved yet)
            # sku cannot dupplicate
            sku = "#{product.id}"
            added_list = []
            variant_values = []
            product_variant[:variant_combinations].each do |attribute_value|
              
              if added_list.include? attribute_value
                next
              end
              attribute_values_found = attribute_value_list.select {|value| value.value.upcase == attribute_value&.upcase}
              attribute_value_found = attribute_values_found.first
              attribute_found = product_attributes.find { |attribute| attribute[:id] == attribute_value_found&.attribute_id }
              if attribute_values_found.length > 0
                sku += "-#{attribute_value_found.id}"
                added_list.push attribute_value
                variant_value = {
                  attribute_id: attribute_found[:id],
                  name: attribute_found[:name],
                  value_id: attribute_value_found.id,
                  value: attribute_value
                }
                variant_values.push(variant_value)
              end
            end

            flat_product = FlatProduct.new(product_id: product.id, price: product_variant[:price].to_f, quantity: product_variant[:quantity].to_i, sku:, variant_values: variant_values.to_json)
            flat_product.save!
            
          end
          
        rescue ActiveRecord::Rollback => e
          raise e.message
        end
        {
          error: nil,
          product: 
        }
      rescue => e
        {error: e.message, product: nil}
      end
    end

    def product_params
      @params.permit(:product_name, :quantity, :price, :unit_id, :category_id, :description, thumbnails: [])
    end

    def variant_params
      @params.permit(attributes: [:name, values: []], product_variants: [
        :price, :quantity, {variant_combinations: []},
      ])
    end
  end
end

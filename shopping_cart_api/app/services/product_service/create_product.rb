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
          raise ActiveRecord::Rollback unless isCreateSuccess

          attributes = @variant_params[:attributes]
          product_variants = @variant_params[:product_variants]

          # check if variant exists, if not create new and add to list
          begin
            product_attribute_values = product.product_attribute_values
            attributes.values.each do |v|
              v[:values].each do |value_id|
                attribute_value = AttributeValue.where(id: value_id, attribute_id: v[:id])
                unless attribute_value.empty?
                  product_attribute_values.create! attribute_value_id: value_id, attribute_id: v[:id]
                end
              end
            end
            
            product_variants.values.each do |v|
              sku = ''
              v[:variant_combinations].each do |vc|
                unless product_attribute_values.where(attribute_value_id: vc).empty?
                  if sku == ''
                  sku += vc.to_s
                  else
                    sku += "-#{vc.to_s}"
                  end
                end
              end
              ProductVariant.create!(
                product: product,
                price: v[:price],
                quantity: v[:quantity],
                sku: sku
              )
            end

          rescue => e
            raise ActiveRecord::Rollback, "Error creating variant: #{e.message}"
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
      @params.permit(attributes: [:id, values: []], product_variants: [
        :price, :quantity, {variant_combinations: []},
      ])
    end
  end
end

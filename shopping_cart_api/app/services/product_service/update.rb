require 'json'

module ProductService
  class Update < ApplicationService
    def initialize(params, product)
      @params = params
      @product = product
    end

    def call
      newThumbnails = @params[:thumbnails]
      ActiveRecord::Base.transaction do 
        begin
          thumbnails_id_to_delete = @params[:thumbnails_id_to_delete]
          if thumbnails_id_to_delete
            thumbnails_to_delete = @product.thumbnails.where(id: thumbnails_id_to_delete)
            thumbnails_to_delete&.each(&:purge)
            @product.reload
          end
        rescue
          raise ActiveRecord::Rollback
        end
        
        if newThumbnails.present?
          begin
            @product.thumbnails.attach(newThumbnails)
          rescue
            raise ActiveRecord::Rollback
          end
          
          unless @product.valid? # validate thumbnails
            raise ActiveRecord::Rollback
          end
        end
        
        success = @product.update(product_params_for_update_normal_properties)
        raise ActiveRecord::Rollback unless success
        
        # ------------------------------------------------------------------------------
        # update variants
        @variant_params = product_params_for_update_variant_properties
        attributes = @variant_params[:attributes]&.values
        product_variants = @variant_params[:product_variants]&.values
        attributes_to_delete = @variant_params[:attributes_to_delete]
        product_variants_to_delete = @variant_params[:product_variants_to_delete]
        
        flat_products = @product.flat_products
        product_attributes = JSON.parse(@product.product_attributes, symbolize_names: true) || []
        begin
          product_variants&.each do |product_variant|
            if product_variant[:id] && product_variants_to_delete&.include?(product_variant[:id]&.to_s)
              next
            end
            # values of dupplicate attribute => cannot insert (this hasn't been solved yet)
            # sku cannot dupplicate
            sku = "#{@product.id}"
            added_list = []
            variant_values = []
            product_variant[:variant_combinations].each do |attribute_value|
              
              if added_list.include? attribute_value
                next
              end
              attribute_value_found = AttributeValue.includes(:product_attribute).find_by(value: attribute_value)
              attribute_found = attribute_value_found.product_attribute
              if attribute_value_found
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

            if product_variant[:id]

              flat_product = FlatProduct.find(product_variant[:id])
              
              if product_variant[:price]
                old_price = flat_product.price
                flat_product.update!(price: product_variant[:price].to_f, old_price: old_price, quantity: product_variant[:quantity].to_i, sku:, variant_values: variant_values.to_json)
              else
                flat_product.update!(quantity: product_variant[:quantity].to_i, sku:, variant_values: variant_values.to_json)
              end
            else
              flat_product = FlatProduct.new(product_id: @product.id, price: product_variant[:price].to_f, quantity: product_variant[:quantity].to_i, sku:, variant_values: variant_values.to_json)
              flat_product.save!
            end
          end

          product_variants_to_delete&.each do |variant_to_delete|
            FlatProduct.find(variant_to_delete&.to_i)&.destroy!
          end

          is_product_attribute_need_to_update = false
          attributes&.each do |attribute_to_handle|
            if attributes_to_delete&.include? attribute_to_handle[:name]
              is_product_attribute_need_to_update = true
              next
            end
            product_attribute_with_same_name = product_attributes.find {|attr| attr[:name].upcase == attribute_to_handle[:name]&.upcase}
            is_exist_attribute =  !product_attribute_with_same_name.nil?

            if is_exist_attribute
              unless attribute_to_handle[:values_to_delete].nil?
                is_product_attribute_need_to_update = true
              end
              attribute_to_handle[:values]&.each do |value|
                unless product_attribute_with_same_name[:values]&.include? value
                  product_attribute_with_same_name[:values].push value
                end
              end
              product_attribute_with_same_name[:values] = product_attribute_with_same_name[:values].filter do |value| 
                !attribute_to_handle[:values_to_delete]&.include? value
              end

              flat_products&.each do |flat_product|
                variant_values = JSON.parse(flat_product[:variant_values], symbolize_names: true)
                sku = "#{@product.id}"
                variant_value_indexes_to_delete = []
                variant_values&.each_with_index do |variant_value, idx|
                  if attribute_to_handle[:values_to_delete]&.include? variant_value[:value]
                    variant_value_indexes_to_delete.push idx
                  else
                    sku += "-#{variant_value[:value_id]}"
                  end
                end

                variant_value_indexes_to_delete&.each do |idx|
                  variant_values.delete_at idx
                end

                flat_product.update! variant_values: variant_values.to_json, sku:
              end

              product_attributes.each do |product_attribute|
                product_attribute[:values] = product_attribute[:values].filter do |value|
                  !attribute_to_handle[:values_to_delete]&.include? value
                end
              end
            else
              is_product_attribute_need_to_update = true
              attribute_found = ProductAttribute.includes(:attribute_values).find_by(name: attribute_to_handle[:name]) # case sensitive still found
              is_attribute_exist_in_db = !attribute_found.nil?
              if is_attribute_exist_in_db
                is_product_had_this_attribute = !product_attributes.find {|attr| attr[:name]&.upcase == attribute_found.name&.upcase}.nil?
                
                attribute_values = []
                attribute_found.attribute_values.where(value: attribute_to_handle[:values])&.each do |value|
                  attribute_values.push(value.value)
                end

                unless is_product_had_this_attribute
                  new_attribute = {
                    id: attribute_found.id,
                    name: attribute_found.name,
                    values: attribute_values
                  }
                  product_attributes.push(new_attribute)
                end
              end
            end
          end

          attributes_to_delete = ProductAttribute.includes(:attribute_values).where(name: attributes_to_delete)
          attributes_to_delete&.each do |attribute_to_delete|
            attribute_to_delete_values = attribute_to_delete.attribute_values
            flat_products&.each do |flat_product|
              variant_values = JSON.parse(flat_product[:variant_values], symbolize_names: true)
              sku = "#{@product.id}"
              variant_value_indexes_to_delete = []
              variant_values&.each_with_index do |variant_value, idx|
                unless attribute_to_delete_values.find_by value: variant_value[:value].nil?
                  variant_value_indexes_to_delete.push idx
                else
                  sku += "-#{variant_value[:value_id]}"
                end
              end
              
              variant_value_indexes_to_delete&.each do |idx|
                variant_values.delete_at idx
              end
              
              flat_product.update! variant_values: variant_values.to_json, sku:
            end

            product_attributes = product_attributes.filter do |attr|
              attributes_to_delete.find_by(name: attr[:name]).nil?
            end
          end

          if is_product_attribute_need_to_update || attributes_to_delete.length > 1
              @product.update! product_attributes: product_attributes.to_json
          end
        rescue => e
          raise ActiveRecord::Rollback, "Error creating variant: #{e.message}"
        end
        
        {
          error: nil,
          product: @product
        }
        
      rescue => e
        return { error: e.message, product: nil }
      end
    end

    def product_params_for_update_normal_properties
      @params.permit(:product_name, :quantity, :price, :unit_id, :category_id, :description)
    end

    def product_params_for_update_variant_properties
      @params.permit(attributes: [:name, values: [], values_to_delete: []], product_variants: [:id, 
        :price, :quantity, variant_combinations: []], attributes_to_delete: [], product_variants_to_delete: [])
    end
  end
end
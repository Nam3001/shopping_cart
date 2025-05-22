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
        attributes = @variant_params[:attributes]
        product_variants = @variant_params[:product_variants]
        attributes_to_delete = @variant_params[:attributes_to_delete]
        product_variants_to_delete = @variant_params[:product_variants_to_delete]


        begin
          product_attribute_values = @product.product_attribute_values

          attributes&.values&.each do |attr|
            attr[:values]&.each do |value_id|
              unless attr[:values_to_delete]&.include? value_id
                attribute_value = AttributeValue.where(id: value_id, attribute_id: attr[:id])
                unless attribute_value.empty?
                  if product_attribute_values.where(attribute_value_id: value_id, attribute_id: attr[:id]).empty?
                    product_attribute_values.create! attribute_value_id: value_id, attribute_id: attr[:id]
                  end
                end
              end
            end

            attr[:values_to_delete]&.each do |value_id|
              product_attribute_values.where(attribute_value_id: value_id, attribute_id: attr[:id]).destroy_all
            end

            @product.product_variants&.each do |product_variant|
              sku_ids = product_variant.sku.split('-')
              new_sku = ''
              sku_ids.each do |sku_id|
                if !attr[:values_to_delete]&.include?(sku_id)
                  if new_sku == ''
                    new_sku += sku_id
                  else
                    new_sku += "-#{sku_id}"
                  end
                end
              end
              product_variant.update!(sku: new_sku)
            end
          end

          attribute_value_ids_of_attributes_to_delete = []
          if !attributes_to_delete.nil? && attributes_to_delete.length > 0
            attribute_list_to_delete = product_attribute_values.where(attribute_id: attributes_to_delete)
            attribute_value_ids_of_attributes_to_delete = attribute_list_to_delete.pluck(:attribute_value_id)
            attribute_list_to_delete.destroy_all
          end

          
          @product.product_variants.each do |product_variant|
            sku_ids = product_variant.sku.split('-')
            new_sku = ''
            sku_ids.each do |sku_id|
              if !attribute_value_ids_of_attributes_to_delete&.include?(sku_id.to_i)
                if new_sku == ''
                  new_sku += sku_id
                else
                  new_sku += "-#{sku_id}"
                end
              end
            end
            product_variant.update!(sku: new_sku)
          end

          # -------------------------------------------------
          product_variants_to_delete&.each do |product_variant_id|
            @product.product_variants.where(id: product_variant_id).destroy_all
          end

          product_variants&.values&.each do |v| 
            if v[:id].nil?
              sku = ''
              v[:variant_combinations]&.each do |vc|
                unless product_attribute_values.where(attribute_value_id: vc).empty?
                  if sku == ''
                    sku += vc.to_s
                  else
                    sku += "-#{vc.to_s}"
                  end
                end
              end
              ProductVariant.create!(
                product: @product,
                price: v[:price],
                quantity: v[:quantity],
                sku: sku
              )
            elsif !product_variants_to_delete&.include? v[:id].to_i
              product_variant = @product.product_variants.find(v[:id])

              value_to_update = {}
              if v[:price].present?
                value_to_update[:price] = v[:price]
              end
              if v[:quantity].present?
                value_to_update[:quantity] = v[:quantity]
              end

              if v[:variant_combinations].present?
                new_sku = ''
                v[:variant_combinations]&.each do |vc|
                  unless product_attribute_values.where(attribute_value_id: vc).empty?
                    if new_sku == ''
                      new_sku += vc.to_s
                    else
                      new_sku += "-#{vc.to_s}"
                    end
                  end
                end

                value_to_update[:sku] = new_sku
                product_variant.update!(value_to_update)
              else
                product_variant.update!(value_to_update)
              end
            end
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
      @params.permit(attributes: [:id, values: [], values_to_delete: []], product_variants: [:id, 
        :price, :quantity, {variant_combinations: []}
      ], attributes_to_delete: [], product_variants_to_delete: [])
    end
  end
end
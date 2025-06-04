require 'json'
class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :price, :quantity, :description, :thumbnails, :created_at, :updated_at, :product_attributes, :variants

  belongs_to :category
  belongs_to :unit

  def thumbnails
    if object.thumbnails.attached?
      object.thumbnails.map do |thumbnail|
        thumbnail_url = Rails.application.routes.url_helpers.rails_blob_url(thumbnail)
        thumbnail_id = thumbnail.id
        {
          thumbnail_id:,
          thumbnail_url:
        }
      end
    else
      []
    end
  end

  def product_attributes
    JSON.parse object.product_attributes, symbolize_names: true unless object.product_attributes.nil?
  end

  def variants
    object.flat_products.map do |flat_product|
      {
        id: flat_product.id,
        quantity: flat_product.quantity,
        price: flat_product.price.to_f,
        old_price: flat_product.old_price.to_f,
        sku: flat_product.sku,
        variant_values: JSON.parse(flat_product.variant_values)
      }
    end
  end
end

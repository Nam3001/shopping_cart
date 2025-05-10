class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :price, :quantity, :unit_id, :created_at, :updated_at, :thumbnail_url

  def thumbnail_url
    if object.thumbnail.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.thumbnail)
    end
  end
end

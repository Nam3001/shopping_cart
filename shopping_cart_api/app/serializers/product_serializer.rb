class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :price, :quantity, :created_at, :updated_at, :thumbnail_url

  belongs_to :category
  belongs_to :unit

  def thumbnail_url
    if object.thumbnail.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.thumbnail)
    end
  end
end

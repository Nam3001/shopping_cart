class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :price, :quantity, :created_at, :updated_at, :thumbnails, :description

  belongs_to :category
  belongs_to :unit

  def thumbnails
    if object.thumbnails.attached?
      object.thumbnails.map do |thumbnail|
        thumbnail_url = Rails.application.routes.url_helpers.rails_blob_url(thumbnail)
        thumbnail_id = thumbnail[:id]
        {
          thumbnail_id:,
          thumbnail_url:
        }
      end
    else
      []
    end
  end
end

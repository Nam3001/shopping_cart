# frozen_string_literal: true

module Types
  class ProductType < Types::BaseObject
    field :id, ID, null: false
    field :product_name, String, null: false
    field :quantity, Integer, null: false
    field :price, Float, null: false
    field :unit_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :thumbnail_url, String, null: true

    def thumbnail_url
      if object.is_a? Product
        object.thumbnail.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.thumbnail) : nil
      else
        if object[:thumbnail_url]
          object[:thumbnail_url]
        else
          begin
            object[:thumbnail]&.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object[:thumbnail]) : nil
          rescue
            nil
          end
        end
      end
    end
  end
end

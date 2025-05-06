class Mutations::Products::Create < Mutations::BaseMutation
  argument :product_name, String, required: true
  argument :price, Float, required: true
  argument :quantity, Integer, required: true
  argument :unit_id, ID, required: true
  argument :thumbnail, ApolloUploadServer::Upload, required: true

  field :product, Types::ProductType, null: true
  field :errors, [ String ], null: false

  def resolve(product_name:, price:, quantity:, unit_id:, thumbnail:)
    authenticate_user!

    product = Product.new(product_name:, price:, quantity:, unit_id:)
    product.thumbnail.attach(
      io: thumbnail,
      filename: thumbnail.original_filename,
      content_type: thumbnail.content_type
    )

    authorize product, :create?, policy_class: ProductPolicy

    if product.save
      {
        product:,
        errors: []
      }
    else
      {
        product: nil,
        errors: product.errors.full_messages
      }
    end
  end
end
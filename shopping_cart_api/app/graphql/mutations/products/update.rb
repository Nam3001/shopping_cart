class Mutations::Products::Update < Mutations::BaseMutation
  argument :id, ID, required: true
  argument :product_name, String, required: false
  argument :price, Float, required: false
  argument :quantity, Integer, required: false
  argument :unit_id, ID, required: false
  argument :thumbnail, ApolloUploadServer::Upload, required: false


  field :product, Types::ProductType, null: true
  field :errors, [ String ], null: false

  def resolve(args)
    authenticate_user!

    product = Product.find_by(id: args[:id])
    authorize product, :update?
  
    unless product
      return { product: nil, errors: ["Product not exist"] }
    end
  
    attributes = args.except(:id, :thumbnail).compact
    thumbnail = args[:thumbnail]
  
    begin
      ActiveRecord::Base.transaction do
        success = product.update(attributes)
        raise ActiveRecord::Rollback unless success
  
        if thumbnail.present?
          product.thumbnail.attach(
            io: thumbnail,
            filename: thumbnail.original_filename,
            content_type: thumbnail.content_type
          )
          unless product.valid? # validate image
            raise ActiveRecord::Rollback
          end
        end
      end
    rescue => e
      return { product: nil, errors: ["Update failed: #{e.message}"] }
    end
  
    if product.errors.any?
      { product: nil, errors: product.errors.full_messages }
    else
      { product: product, errors: [] }
    end
  end
end
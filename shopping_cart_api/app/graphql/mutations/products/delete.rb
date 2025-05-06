class Mutations::Products::Delete < Mutations::BaseMutation
  argument :id, ID, required: true

  field :success, Boolean, null: false
  field :errors, [ String ], null: false

  def resolve(id:)
    authenticate_user!

    begin
      product = Product.find id
      authorize product, :destroy?

      if product.destroy
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: product.errors.full_messages
        }
      end
    rescue => e 
      {
        success: false,
        errors: [ e.message ]
      }
    end
  end
end
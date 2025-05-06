class Queries::Products::Show < Queries::BaseQuery
  argument :id, ID, required: true
  type Types::ProductType, null: true

  def resolve(id:)
    Product.find(id)
  end
end
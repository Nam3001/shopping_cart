module Types
  class ProductConnectionType < Types::BaseObject
    field :products, [Types::ProductType], null: false
    field :pagination, Types::PaginationType, null: false
  end
end
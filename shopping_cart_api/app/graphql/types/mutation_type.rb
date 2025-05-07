# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_product, mutation: Mutations::Products::Create
    field :update_product, mutation: Mutations::Products::Update
    field :delete_product, mutation: Mutations::Products::Delete
    field :login, mutation: Mutations::Users::Login
    field :logout, mutation: Mutations::Users::Logout
    field :refresh, mutation: Mutations::Users::Refresh
  end
end

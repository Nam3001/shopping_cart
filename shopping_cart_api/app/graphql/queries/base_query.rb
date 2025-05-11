module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    def authenticate_user!
      raise GraphQL::ExecutionError, 'Need to logged in to use this feature' unless context[:current_user]
    end

    def authorize(record, query = :show?, policy_class: nil)
      policy = policy_class ? policy_class.new(context[:current_user], record) : Pundit.policy!(context[:current_user], record)
      raise GraphQL::ExecutionError, 'Access denied' unless policy.public_send(query)
    end
  end
end
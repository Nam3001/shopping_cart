# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def authenticate_user!
      raise GraphQL::ExecutionError, 'Bạn cần đăng nhập' unless context[:current_user]
    end

    def authorize(record, query = :show?, policy_class: nil)
      policy = policy_class ? policy_class.new(context[:current_user], record) : Pundit.policy!(context[:current_user], record)
      raise GraphQL::ExecutionError, 'Không có quyền truy cập' unless policy.public_send(query)
    end
  end
end

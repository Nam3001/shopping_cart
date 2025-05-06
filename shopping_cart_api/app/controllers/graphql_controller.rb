# frozen_string_literal: true

class GraphqlController < ApplicationController
  skip_before_action :authenticate
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    user, payload, access_token = authenticate_request
    context = {
      current_user: user,
      payload:,
      access_token:
    }
    result = ShoppingCartApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end

  def authenticate_request
    auth_header = request.headers["Authorization"]

    token = auth_header.split(" ").last if auth_header
    if token.nil?
      [ nil, nil, nil ]
    else
      begin
        payload = JsonWebToken.decode(token).with_indifferent_access
        user = User.find(payload[:user_id])
        [ user, payload, token ]
      rescue
        [ nil, nil, token ]
      end
    end
  end
end

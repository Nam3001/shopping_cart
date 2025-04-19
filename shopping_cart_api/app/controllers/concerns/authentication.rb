module Authentication
  extend ActiveSupport::Concern

  attr_reader :current_user

  included do
    before_action :authenticate
    rescue_from JWT::DecodeError, with: :decode_error
    rescue_from JWT::VerificationError, with: :invalid_token
    rescue_from JWT::ExpiredSignature, with: :expired_token
  end

  private

  def authenticate
    authorize_header = request.headers['Authorization']
    token = authorize_header.split(' ').last if authorize_header
    decoded_token = JsonWebToken.decode(token)

    if(JsonWebToken.blacklisted? decoded_token[:jti])
      render json: { error: 'Token has been revoked' }, status: :unauthorized
      return
    end

    Rails.logger.debug "authenticate"
    @current_user = User.find(decoded_token[:user_id])
  end


  def invalid_token(e)
    # Rails.logger.debug(e.message)
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  def decode_error
    render json: { error: 'Decode error' }, status: :unauthorized
  end

  def expired_token
    render json: { error: 'Token has expired' }, status: :unauthorized
  end
end
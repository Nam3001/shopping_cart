class ApplicationController < ActionController::API
  before_action :authenticate

  # rescue_from JWT::DecodeError, with: :decode_error
  # rescue_from JWT::VerificationError, with: :invalid_token
  # rescue_from JWT::ExpiredSignature, with: :expired_token
  rescue_from JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature, with: :invalid_token

  attr_reader :current_user
  
  private

  def authenticate 
    authorize_header = request.headers['Authorization']
    token = authorize_header.split(' ').last if authorize_header
    decoded_token = JsonWebToken.decode(token)

    @current_user = User.find(decoded_token[:user_id])
  end

  def invalid_token
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  # def decode_error
  #   render json: { error: 'Decode error' }, status: :unauthorized
  # end

  # def expired_token
  #   render json: { error: 'Token has expired' }, status: :unauthorized
  # end
end

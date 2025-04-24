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

    if decoded_token[:type].eql? 'refresh'
      render json: { error: 'Cannot authenticate using refresh token' }, status: :unauthorized
    end

    # checking user either exist or not
    @current_user = User.find(decoded_token[:user_id])
    if @current_user.nil?
      render json: { error: 'User is not exist' }, status: :unauthorized
      return
    elsif JsonWebToken.blacklisted? decoded_token[:jti]
      render json: { error: 'Token has been revoked' }, status: :unauthorized
      return
    end

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User is not exist' }, status: :unauthorized
  end


  def invalid_token(e)
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  def decode_error
    render json: { error: 'Decode error' }, status: :unauthorized
  end

  def expired_token
    render json: { error: 'Token has expired' }, status: :unauthorized
  end
end
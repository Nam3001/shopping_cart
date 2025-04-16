class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate, only: [:login, :refresh]
  
  def login
    user = User.find_by(username: params[:username])
    
    if user&.authenticate(params[:password])
      payload = { user_id: user.id }

      access_token = JsonWebToken.encode_access_token(payload)
      refresh_token = JsonWebToken.encode_refresh_token(payload)

      expire_at = JsonWebToken::ACCESS_TOKEN_EXPIRE.from_now.to_i

      render json: { access_token: access_token, refresh_token: access_token, expire_at: expire_at }, status: :ok

    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def refresh 
    refresh_token = params[:refresh_token]
    payload = JsonWebToken.decode(refresh_token)

    new_access_token = JsonWebToken.encode_access_token({ user_id: payload[:user_id]})

    render json: { access_token: new_access_token }, status: :ok
  rescue JWT::ExpiredSignature
    render json: { error: "expired signature" }, status: :unauthorized
  rescue JWT::VerificationError
    render json: { error: "invalid token" }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { error: "decode error" }, status: :unauthorized
  end

  def logout 
    authorize_header = request.headers['Authorization']
    token = authorize_header.split(' ').last if authorize_header
    
    decoded_token = JsonWebToken.decode(token)

    TokenBlackList.create!(
      jti: decoded_token[:jti],
      exp: Time.at(decoded_token[:exp])
    )

    render json: { message: 'Logged out successfully' }, status: :ok
  rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError => e
    render json: { error: e.message }, status: :unauthorized
  end
end

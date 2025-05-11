

class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate, only: [:login, :refresh, :logout]
  
  def login
    user = User.find_by(username: params[:username])
    
    if user&.authenticate(params[:password])
      payload = { user_id: user.id }

      access_token = JsonWebToken.encode_access_token(payload)
      refresh_token = JsonWebToken.encode_refresh_token(payload)

      render json: { access_token: access_token, refresh_token: refresh_token }, status: :ok

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

    unless token
      render json: { message: 'Logged out successfully' }, status: :ok
      return
    end

    decoded_token = JsonWebToken.decode(token)

    
    # checking user either exist or not
    @current_user = User.find(decoded_token[:user_id])
    if @current_user.nil?
      render json: { message: 'Logged out successfully' }, status: :ok
      return
    elsif JsonWebToken.blacklisted? decoded_token[:jti]
      render json: { message: 'Logged out successfully' }, status: :ok
      return
    end


    TokenBlackList.create!(
      jti: decoded_token[:jti],
      exp: Time.at(decoded_token[:exp])
    )

    render json: { message: 'Logged out successfully' }, status: :ok
  rescue
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  def me
    render json: @current_user.to_json(except: [:password_digest]), status: :ok
  end
end

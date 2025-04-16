class Api::V1::AuthController < ApplicationController
  def login
    user = User.find_by(username: params[:username])
    
    if user&.authenticate(params[:password])
      payload = { user_id: user.id }
      token = JsonWebToken.encode(payload)
      expire_at = JsonWebToken.decode(token)[:exp]

      render json:  { token:, expire_at: }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def logout 
  end
end

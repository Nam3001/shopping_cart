class JsonWebToken
  SECRET_KEY = ENV["AUTH_SECRET"] || Rails.application.credentials.dig(:secret_key_base)
  ALGORITHM = 'HS256'
  ACCESS_TOKEN_EXPIRE = 10.minutes
  REFRESH_TOKEN_EXPIRE =  7.days

  def self.encode_access_token(payload, exp = ACCESS_TOKEN_EXPIRE.from_now.to_i)
    payload[:exp] = exp
    payload[:jti] = SecureRandom.uuid
    payload[:type] = 'access'
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.encode_refresh_token(payload, exp = REFRESH_TOKEN_EXPIRE.from_now.to_i)
    payload[:exp] = exp
    payload[:jti] = SecureRandom.uuid
    payload[:type] = 'refresh'
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM }).first
    HashWithIndifferentAccess.new body
  end

  def self.blacklisted?(jti)
    TokenBlackList.exists?(jti: jti)
  end
end
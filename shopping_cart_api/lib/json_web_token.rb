class JsonWebToken
  SECRET_KEY = ENV["AUTH_SECRET"] || Rails.application.credentials.dig(:secret_key_base)
  ALGORITHM = 'HS256'

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM }).first
    HashWithIndifferentAccess.new body
  end
end
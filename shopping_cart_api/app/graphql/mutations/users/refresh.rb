class Mutations::Users::Refresh < Mutations::BaseMutation
  argument :refresh_token, String, required: false

  field :access_token, String, null: true
  field :errors, [ String ], null: false

  def resolve(refresh_token:)
    payload = JsonWebToken.decode(refresh_token)

    new_access_token = JsonWebToken.encode_access_token({ user_id: payload[:user_id]})

    { access_token: new_access_token, errors: [] }
  rescue JWT::ExpiredSignature
    { errors: [ "expired signature" ] }
  rescue JWT::VerificationError
    { errors: [ "invalid token" ] }
  rescue JWT::DecodeError
   { errors: [ "decode error" ] }
  end
end
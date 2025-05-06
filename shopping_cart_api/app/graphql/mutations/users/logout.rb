class Mutations::Users::Logout < Mutations::BaseMutation
  field :success, Boolean, null: false
  field :errors, [ String ], null: false

  def resolve
    token = context[:access_token]
    decoded_token = JsonWebToken.decode(token)

    TokenBlackList.create!(
      jti: decoded_token[:jti],
      exp: Time.at(decoded_token[:exp])
    )

    {
      success: true,
      errors: []
    }
  rescue JWT::ExpiredSignature
    # token hết hạn thì vẫn logout thành công
    {
      success: true,
      errors: []
    }
  rescue JWT::DecodeError, JWT::DecodeError => e
    {
      success: false,
      errors: [ e.message ]
    }
  rescue JWT::DecodeError, JWT::VerificationError => e
    {
      success: false,
      errors: [ e.message ]
    }
  end

end
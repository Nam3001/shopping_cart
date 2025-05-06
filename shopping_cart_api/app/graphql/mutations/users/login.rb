class Mutations::Users::Login < Mutations::BaseMutation
  null false

  argument :username, String, required: true
  argument :password, String, required: true

  field :access_token, String, null: true
  field :refresh_token, String, null: true
  field :errors, [ String ], null: false

  def resolve(username:, password:)
    user = User.find_by(username: username)
    
    if user&.authenticate(password)
      payload = { user_id: user.id }

      access_token = JsonWebToken.encode_access_token(payload)
      refresh_token = JsonWebToken.encode_refresh_token(payload)

      {
        access_token:,
        refresh_token:,
        errors: []
      }      
    else
      {
        access_token: nil,
        refresh_token: nil,
        errors: [ "invalid email or password" ]
      }
    end
  end
end

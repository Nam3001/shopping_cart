module Authorization
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

   
  private
  def user_not_authorized
    render json: { error: "User are not authorized to perform this action" }, status: :forbidden
  end
end
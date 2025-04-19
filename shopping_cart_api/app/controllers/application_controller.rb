class ApplicationController < ActionController::API
  include Pundit::Authorization
  include Authorization
  include Authentication

end

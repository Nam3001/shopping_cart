require 'rails_helper'

def json_response
  JSON.parse(response.body)
end

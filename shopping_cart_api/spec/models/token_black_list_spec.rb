require 'rails_helper'

RSpec.describe TokenBlackList, type: :model do 
  describe 'validation' do 
    it { should validate_presence_of :jti }
    it { should validate_presence_of :exp }
  end
end

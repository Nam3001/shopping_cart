require 'rails_helper'

RSpec.describe User, type: :model do
  describe "association" do
    it { should have_many :cart_items }
    it { should have_many(:products).through(:cart_items) }
    it { should have_many(:orders).dependent(:restrict_with_exception) }
    
  end

  describe "validation" do 
    it { should validate_presence_of :username }
    it { should validate_length_of(:username).is_at_least(6) }
    it { should validate_uniqueness_of(:username) }

    it { should validate_presence_of :address }
    it { should validate_presence_of :email_address }
    it { should validate_uniqueness_of(:email_address).case_insensitive }

    
    it 'email_address format' do 
      expect(build(:user)).to be_valid
      expect(build(:user)).not_to allow_value('abc').for(:email_address) 
      # should allow_value('abc').for(:email_address) 
      
    end

    it 'check is admin' do 
      user1 = build(:user, role: :user)
      user2 = build(:user, role: :admin)

      expect(user1).not_to be_admin
      expect(user2).to be_admin
    end
    
    it 'factory' do 
      expect(build(:user, role: :admin)).to be_valid
      expect(build(:user, role: :user)).to be_valid
    end
  end
  
end

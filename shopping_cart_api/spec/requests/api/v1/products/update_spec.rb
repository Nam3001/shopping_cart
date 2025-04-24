RSpec.describe "Api::V1::ProductsController", type: :request do
  describe 'patch #update' do
    let(:update_path) { '/api/v1/products' }
    let(:product) { create :product }
    let(:user_dont_have_permit) { create :user, role: :user }
    let(:user_have_permit) { create :user, role: :admin, username: 'User12345', email_address: 'user_have_permit@gmail.com' }

    # before do
    #   allow_any_instance_of(Api::V1::ProductsController).to receive(:authenticate).and_return true
    # end
    
    it do
      allow_any_instance_of(Api::V1::ProductsController).to receive(:authenticate).and_raise JWT::DecodeError
      patch "#{update_path}/#{product.id}"
      expect(response).to have_http_status :unauthorized
    end

    it 'user dont have permit to update' do
      access_token = JsonWebToken.encode_access_token({ user_id: user_dont_have_permit['id'] })

      patch "#{update_path}/#{product.id}", headers: {
        Authorization: "Bearer #{access_token}"
      }, params: {
        product_name: 'new product name'
      }
      expect(response).to have_http_status :forbidden
    end

    it 'update with permitted user' do
      access_token = JsonWebToken.encode_access_token({ user_id: user_have_permit['id'] })
      new_product_name = 'new product name'

      patch "#{update_path}/#{product.id}", headers: {
        Authorization: "Bearer #{access_token}"
      }, params: {
        product_name: new_product_name
      }
      expect(response).to have_http_status :ok
      expect(Product.find(product.id).product_name).to eq new_product_name
      
    end
  end
end
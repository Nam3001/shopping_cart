RSpec.describe "Api::V1::ProductsController", type: :request do
  describe 'post #create' do
    let(:unit) { create :unit }
    let(:product) { create :product, unit: unit }
    let(:create_path) { '/api/v1/products' }
    let(:user_dont_have_permit) { create :user, role: :user }
    let(:user_have_permit) { create :user, role: :admin }

    # before do
    #   allow_any_instance_of(Api::V1::ProductsController).to receive(:authenticate).and_return true
    # end

    
    it 'unauthenticate user' do 
      allow_any_instance_of(Api::V1::ProductsController).to receive(:authenticate).and_raise JWT::DecodeError
      post create_path, params: product.attributes

      expect(response).to have_http_status :unauthorized
    end

    it 'user dont have permit to create' do
      access_token = JsonWebToken.encode_access_token({ user_id: user_dont_have_permit['id'] })

      post create_path, headers: {
        Authorization: "Bearer #{access_token}"
      }, params: product.attributes

      expect(response).to have_http_status :forbidden
    end

    it 'user have permit to create' do
      image = fixture_file_upload(Rails.root.join('spec/fixtures/files/valid_image.png'), 'image/png')
      
      valid_attributes = {
          product_name: product['product_name'],
          quantity: product['quantity'],
          price: product['price'],
          unit_id: product['unit_id'],
          thumbnail: image
        }

      access_token = JsonWebToken.encode_access_token({ user_id: user_have_permit['id'] })

      post create_path, headers: {
        Authorization: "Bearer #{access_token}"
      }, params: valid_attributes,
      as: :multipart
        
      expect(response).to have_http_status :created
    end

    it 'check invalid attribute' do
      valid_attributes = {
          product_name: product['product_name'],
          quantity: product['quantity'],
          price: product['price'],
          unit_id: product['unit_id'],
        }

      access_token = JsonWebToken.encode_access_token({ user_id: user_have_permit['id'] })

      post create_path, headers: {
        Authorization: "Bearer #{access_token}"
      }, params: valid_attributes,
      as: :multipart
        
      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
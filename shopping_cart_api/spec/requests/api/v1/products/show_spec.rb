require_relative '../common'

RSpec.describe "Api::V1::ProductsController", type: :request do
  describe 'get #show' do
    let(:api_v1_path) { '/api/v1' }
    let(:product) { create :product }
    let(:show_path) { "#{api_v1_path}/products"}

    it 'product exist' do
      get "#{show_path}/#{product.id}"
      
      expect(json_response['id']).to eq product.id
    end

    it 'product is not exist' do
      not_exist_id = -1
      get "#{show_path}/#{not_exist_id}"

      expect(response).to have_http_status :not_found
    end
  end
end
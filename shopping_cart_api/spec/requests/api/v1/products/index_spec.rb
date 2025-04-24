require 'rails_helper'

RSpec.describe "Api::V1::ProductsController", type: :request do
  let(:product) { create(:product) }
  let(:api_v1_path) { '/api/v1' }
  let(:unit) { create :unit, unit_name: 'chiếc' }


  describe 'get #index' do
  
    context 'user authenticated' do
      let(:index_path) { "#{api_v1_path}/products"}
    
      it "does not require authentication" do
        get index_path
        expect(response).to have_http_status(:ok)

        expect {json_response}.not_to raise_error

        expect(json_response).to have_key 'data'
        expect(json_response).to have_key 'pagination'
      end  

      it 'check pagination' do
        get index_path,  params: { page: 2, per_page: 1 }

        expect(json_response['pagination']['current_page']).to eq 2
      end

      it "authorizes the index action" do
        page = 2
        per_page = 1
        products = Product.with_attached_thumbnail.page(page).per(per_page)
        allow_any_instance_of(Api::V1::ProductsController).to receive(:authorize).with(products)
        get index_path, params: { page:, per_page: }
      end
    end

  end

end
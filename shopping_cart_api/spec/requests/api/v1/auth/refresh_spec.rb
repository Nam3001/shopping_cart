require_relative '../common'

RSpec.describe "Api::V1::Auth::refresh", type: :request do
  let(:api_v1_path) { '/api/v1/auth' }

  describe "POST api/v1/auth/refresh" do
    it 'dont pass token' do
      post "#{api_v1_path}/refresh"
      expect(response).to have_http_status :unauthorized
      expect(json_response).to have_key 'error'
    end

    context "valid refresh token" do
      let(:refresh_token) { JsonWebToken.encode_refresh_token({ user_id: 1 }, 1.minutes.from_now.to_i) }
      let(:params) { { refresh_token: refresh_token } } 

      before { post "#{api_v1_path}/refresh", params: params }

      it do
        expect(response).to have_http_status :ok
        expect(json_response).to have_key "access_token"
      end
    end
    
    context "expired refresh token" do
      let(:refresh_token) { JsonWebToken.encode_refresh_token({ user_id: 1 }, 1.days.ago.to_i) }
      let(:params) { { refresh_token: refresh_token } } 

      before { post "#{api_v1_path}/refresh", params: params }

      it do
        expect(response).to have_http_status :unauthorized
        expect(json_response).to have_key 'error'
      end
    end

    context "invalid refresh token" do
      let(:refresh_token) { JsonWebToken.encode_refresh_token({ user_id: 1 }) }
      let(:params) { { refresh_token: refresh_token.slice(0, refresh_token.length - 1) } }  # invalid refresh token

      before { post "#{api_v1_path}/refresh", params: params }

      it do
        expect(response).to have_http_status :unauthorized
        expect(json_response).to have_key 'error'
      end
    end

    context 'access token of user dont exists' do 
      let(:access_token) { JsonWebToken.encode_access_token({ user_id: -1 }) }
      let(:headers) { { Authorization: "Bearer #{access_token}" }}

      before { post("#{api_v1_path}/refresh", headers: headers) }
      it do 
        expect(response).to have_http_status :unauthorized
        expect(json_response).to have_key('error')
      end 
    end
  end
end
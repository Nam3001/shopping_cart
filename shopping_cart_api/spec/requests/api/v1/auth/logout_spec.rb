require_relative '../common'

RSpec.describe "Api::V1::Auth::logout", type: :request do
  let(:api_v1_path) { '/api/v1/auth' }

  describe "DELETE api/v1/auth/logout" do
    it 'dont pass token' do
      delete "#{api_v1_path}/logout"
      expect(response).to have_http_status :unauthorized
      expect(json_response).to have_key 'error'
    end

    context 'valid token' do
      let(:access_token) { JsonWebToken.encode_access_token({ user_id: 1 }) }
      let(:headers) {{ Authorization: "Bearer #{access_token}" }}

      before { delete "#{api_v1_path}/logout", headers: headers }

      it { expect(response).to have_http_status(:ok) }
      it { expect(json_response).to have_key('message') }

      it 'add to blacklist' do 
        access_token = JsonWebToken.encode_access_token({ user_id: 1 }) 
        headers = { Authorization: "Bearer #{access_token}" }
        expect { delete "#{api_v1_path}/logout", headers: headers }.to change(TokenBlackList, :count).by 1
      end
    end

    context 'expired token' do
      let(:access_token) { JsonWebToken.encode_access_token({ user_id: 1 }, 1.days.ago.to_i) }
      let(:headers) { { Authorization: "Bearer #{access_token}" }}

      before { delete "#{api_v1_path}/logout", headers: headers }
      it do
        expect(response).to have_http_status :ok
        expect(json_response).to have_key 'message'
      end
    end

    context 'invalid token' do
      let(:access_token) { JsonWebToken.encode_access_token({ user_id: 1 }, 1.days.ago.to_i) }
      let(:headers) { { Authorization: "Bearer #{access_token.slice(0, access_token.length - 1)}" }} # invalid token

      before { delete "#{api_v1_path}/logout", headers: headers }
      it do
        expect(response).to have_http_status :unauthorized
        expect(json_response).to have_key 'error'
      end
    end

    context 'access token of user dont exists' do 
      let(:access_token) { JsonWebToken.encode_access_token({ user_id: -1 }) }
      let(:headers) { { Authorization: "Bearer #{access_token}" }}

      before { post("#{api_v1_path}/login", headers: headers) }
      it do 
        expect(response).to have_http_status :unauthorized
        expect(json_response).to have_key('error')
      end 
    end
  end
end
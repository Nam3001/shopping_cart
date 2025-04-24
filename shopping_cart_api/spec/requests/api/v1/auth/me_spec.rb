require_relative '../common'

RSpec.describe "Api::V1::Auth::me", type: :request do
  let(:api_v1_path) { '/api/v1/auth' }
  
  describe "POST api/v1/auth/me" do
    it 'dont pass token' do
      get "#{api_v1_path}/me"
      expect(response).to have_http_status :unauthorized
      expect(json_response).to have_key 'error'
    end

    context 'valid token' do
      let(:access_token) { JsonWebToken.encode_access_token({ user_id: 1 }) }
      let(:headers) {{ Authorization: "Bearer #{access_token}" }}

      before { get "#{api_v1_path}/me", headers: headers }

      it { expect(response).to have_http_status(:ok) }
      it { expect(json_response).not_to have_key('password_digest') }
      it { expect(json_response).to have_key('username') }
      it { expect(json_response).to have_key('fullname') }
      it { expect(json_response).to have_key('address') }
      it { expect(json_response).to have_key('email_address') }
    end

    context 'expired token' do
      let(:access_token) { JsonWebToken.encode_access_token({ user_id: 1 }, 1.days.ago.to_i) }
      let(:headers) { { Authorization: "Bearer #{access_token}" }}

      before { get "#{api_v1_path}/me", headers: headers }
      it do
        expect(response).to have_http_status :unauthorized
        expect(json_response).to have_key 'error'
      end
    end

    context 'invalid token' do
      let(:access_token) { JsonWebToken.encode_access_token({ user_id: 1 }, 1.days.ago.to_i) }
      let(:headers) { { Authorization: "Bearer #{access_token.slice(0, access_token.length - 1)}" }} # invalid token

      before { get "#{api_v1_path}/me", headers: headers }
      it do
        expect(response).to have_http_status :unauthorized
        expect(json_response).to have_key 'error'
      end
    end
    

    context 'access token of user dont exists' do 
      let(:access_token) { JsonWebToken.encode_access_token({ user_id: -1 }) }
      let(:headers) { { Authorization: "Bearer #{access_token}" }}

      before { get "#{api_v1_path}/me", headers: headers }
      it do 
        expect(response).to have_http_status :unauthorized
        expect(json_response).to have_key('error')
      end 
    end
  end
end
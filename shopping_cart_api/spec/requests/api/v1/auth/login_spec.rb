require_relative '../common'

RSpec.describe "Api::V1::Auth::login", type: :request do
  let(:user) { build(:user, username: 'Nvn3001', password: 'Nam300103') }
  let(:valid_credentials) { { username: user.username, password: user.password } }
  let(:invalid_credentials1) { { username: user.username, password: 'wrong' } } # wrong password
  let(:invalid_credentials2) { { username: 'notexistuser', password: 'wrong' } } # not exist user
  let(:api_v1_path) { '/api/v1/auth' }

  it 'dont pass credentials' do
    post "#{api_v1_path}/login"
    expect(response).to have_http_status :unauthorized
    expect(json_response).to have_key 'error'
  end

  context 'with valid credentials' do
    before { post("#{api_v1_path}/login", params: valid_credentials) }

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns an access token' do
      expect(json_response).to have_key('access_token')
    end

    it 'returns a refresh token' do
      expect(json_response).to have_key('refresh_token')
    end
  end

  context 'with invalid credentials 1 (wrong password)' do 
    before { post("#{api_v1_path}/login", params: invalid_credentials1) }
    it do 
      expect(response).to have_http_status :unauthorized
      expect(json_response).to have_key('error')
    end 
  end

  context 'with invalid credentials 2 (not exists username)' do 
    before { post("#{api_v1_path}/login", params: invalid_credentials2) }
    it do 
      expect(response).to have_http_status :unauthorized
      expect(json_response).to have_key('error')
    end 
  end
end
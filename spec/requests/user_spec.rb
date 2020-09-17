require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe 'Users', type: :request do
  let(:signup) do
    get '/users/sign_up'
    post '/users', params: {
      user: {
        name: 'Lucas',
        email: 'lucas@lucas.com',
        password: '123456',
        password_confirmation: '123456'
      }
    }
  end

  let(:signin) do
    get '/users/sign_in'
    post '/users', params: { user: { id: 1, email: 'lucas@lucas.com', password: '123456' } }
  end

  context 'when user tries to access root without signing in' do
    it 'redirects to signin page' do
      get '/posts'
      expect(response).to redirect_to('/users/sign_in')
    end
  end

  context 'when user tries to access root signed in' do
    before do
      DatabaseCleaner.clean
      signup
      signin
    end

    it 'opens page' do
      get '/posts'
      expect(response).to have_http_status(:ok)
    end
  end
end

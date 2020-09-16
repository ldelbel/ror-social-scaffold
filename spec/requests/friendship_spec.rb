require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

RSpec.describe 'Friendship', type: :request do
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

  context 'when user tries to access friendships without signing in' do
    it 'redirects to signin page' do
      get user_friendships_path(1)
      expect(response).to redirect_to('/users/sign_in')
    end
  end

  context 'when user tries to access friendships page signed in' do
    before do
      signup
      signin
    end

    it 'opens page' do
      get user_friendships_path(1)
      expect(response).to have_http_status(:ok)
    end
  end
end

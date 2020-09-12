require 'rails_helper'
require 'database_cleaner'


RSpec.describe 'Users', type: :feature do
  describe 'Sign Up' do
    context 'when user add valid inputs' do
      before do
        DatabaseCleaner.clean
        User.create(name: 'Lucas')
        visit '/users/sign_up'
        fill_in 'user_name', with: 'Delbel'
        fill_in 'user_email', with: 'del@bel.com'
        fill_in 'user_password', with: '123456'
        fill_in 'user_password_confirmation', with: '123456'
        click_on 'commit'
      end

      it 'signs in' do
        expect(page).to have_content('Recent posts')
      end

      it 'flashes success message' do
        expect(page).to have_content('Welcome! You have signed up successfully.')
      end

      it 'register user in All Users' do
        click_link 'Sign out'
        visit '/users/sign_up'
        fill_in 'user_name', with: 'Lucas'
        fill_in 'user_email', with: 'luc@as.com'
        fill_in 'user_password', with: '123456'
        fill_in 'user_password_confirmation', with: '123456'
        click_on 'commit'
        visit '/users'
        expect(page).to have_content('Delbel')      
      end
    end

    context 'when user add password too short' do
      before do
        DatabaseCleaner.clean
        visit '/users/sign_up'
        fill_in 'user_name', with: 'Delbel'
        fill_in 'user_email', with: 'del@bel.com'
        fill_in 'user_password', with: '1234'
        fill_in 'user_password_confirmation', with: '1234'
        click_on 'commit'
      end

      it 'reloads sign up page' do
        expect(page).to have_content('Sign up')
      end

      it 'flashes short_password error' do
        expect(page).to have_content('Password is too short (minimum is 6 characters)')
      end     
    end

    context 'when user add wrong password confirmation' do
      before do
        DatabaseCleaner.clean
        visit '/users/sign_up'
        fill_in 'user_name', with: 'Delbel'
        fill_in 'user_email', with: 'del@bel.com'
        fill_in 'user_password', with: '123456'
        fill_in 'user_password_confirmation', with: '12345'
        click_on 'commit'
      end

      it 'reloads sign up page' do
        expect(page).to have_content('Sign up')
      end

      it 'flashes short_password error' do
        expect(page).to have_content('Password confirmation doesn\'t match Password')
      end     
    end
  end

  describe 'Sign In and Out' do
    context 'when user add valid inputs' do
      before do
        DatabaseCleaner.clean
        User.create(name: 'Delbel', email: 'del@bel.com', password: '123456', password_confirmation: '123456')
        visit '/users/sign_in'
        fill_in 'user_email', with: 'del@bel.com'
        fill_in 'user_password', with: '123456'
        click_on 'commit'
      end
      
      it 'signs in' do
        expect(page).to have_content('Recent posts')
      end
      
      it 'flashes success message' do
        expect(page).to have_content('Signed in successfully.')
      end

      it 'enables sign out link' do
        expect(page).to have_content('Sign out')
      end
    end

    context 'when user add invalid inputs' do
      before do
        DatabaseCleaner.clean
        User.create(name: 'Delbel', email: 'del@bel.com', password: '123456', password_confirmation: '123456')
        visit '/users/sign_in'
        fill_in 'user_email', with: 'del@bel.com'
        fill_in 'user_password', with: '1234'
        click_on 'commit'
      end
      
      it 'reloads sign in page' do
        expect(page).to have_content('Sign in')
      end
      
      it 'flashes error message' do
        expect(page).to have_content('Invalid Email or password.')
      end
    end

    context 'when user signs out' do
      before do
        DatabaseCleaner.clean
        User.create(name: 'Delbel', email: 'del@bel.com', password: '123456', password_confirmation: '123456')
        visit '/users/sign_in'
        fill_in 'user_email', with: 'del@bel.com'
        fill_in 'user_password', with: '123456'
        click_on 'commit'   
      end
      
      it 'loads sign in page' do
        click_link 'Sign out'
        expect(page).to have_content('Sign in')
      end
      
      it 'flashes warning message' do
        click_link 'Sign out'
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end
  end
end
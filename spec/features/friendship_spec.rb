require 'rails_helper'
require 'database_cleaner'


RSpec.describe 'Friendships', type: :feature do
  describe 'friendship_buttons' do
    before do
      DatabaseCleaner.clean
      User.create(name: 'Lucas', email: 'luc@as.com', password: '123456', password_confirmation: '123456')
      User.create(name: 'Delbel', email: 'del@bel.com', password: '123456', password_confirmation: '123456')
      visit '/users/sign_in'
      fill_in 'user_email', with: 'luc@as.com'
      fill_in 'user_password', with: '123456'
      click_on 'commit'
      visit '/users'
      click_on 'commit'
    end
    
    context 'when user clicks on Send Invitation button in All Users' do      
      it 'Changes the button content to Cancel Invitation' do
        expect(page).to have_button('Cancel Invitation')
      end

      it 'Raises success message' do
        expect(page).to have_content('Invitation sent successfully')
      end

      it 'Creates friendship request' do
        click_link 'Sign out'
        visit '/users/sign_in'
        fill_in 'user_email', with: 'del@bel.com'
        fill_in 'user_password', with: '123456'
        click_on 'commit'
        visit '/users/2/friendships'
        expect(page).to have_button('Accept')
      end
    end

    context 'when user clicks on Cancel Invitation button in All Users' do
      before do
        click_on 'commit'
      end

      it 'Changes the button content to Send Invitation' do
        expect(page).to have_button('Send Invitation')
      end

      it 'Raises warning message' do
        expect(page).to have_content('You canceled the invitation')
      end

      it 'Destroys friendship request' do
        click_link 'Sign out'
        visit '/users/sign_in'
        fill_in 'user_email', with: 'del@bel.com'
        fill_in 'user_password', with: '123456'
        click_on 'commit'
        visit '/users/2/friendships'
        expect(page).not_to have_button('Accept')
        expect(page).to have_content('Requests')
      end
    end

    context 'when user clicks on Check Pending Request button in All Users' do
      before do
        #simulates logout user 1 -> login user2 -> send friend request to user1 -> logout -> login user1 -> check request
        click_on 'commit'
        click_link 'Sign out'
        visit '/users/sign_in'
        fill_in 'user_email', with: 'del@bel.com'
        fill_in 'user_password', with: '123456'
        click_on 'commit'
        visit '/users'
        click_on 'commit'
        click_link 'Sign out'
        visit '/users/sign_in'
        fill_in 'user_email', with: 'luc@as.com'
        fill_in 'user_password', with: '123456'
        click_on 'commit'
        visit '/users'
        click_on 'commit'
      end

      it 'Redirects to Requests page' do
        expect(page).to have_content('Requests')
      end

      it 'Shows accept and decline buttons' do
        expect(page).to have_button('Accept')
        expect(page).to have_button('Decline')
      end
    end 
  end
end
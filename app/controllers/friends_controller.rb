class FriendsController < ApplicationController
  def index
    @user = current_user
    @user_friends1 = current_user.friendships_as_requester.where(status: true).pluck(:friend2_id)
    @user_friends2 = current_user.friendships_as_receiver.where(status: true).pluck(:friend1_id)
    @user_friends = @user_friends1 + @user_friends2
  end
end

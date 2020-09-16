class FriendsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = current_user
    @user_friends = @user.friends
  end
end

class FriendshipsController < ApplicationController
  include FriendshipsHelper
  before_action :authenticate_user!

  def index
    @user = current_user

  end

  def new
    @friendship = Friendship.new
  end

  def create
    @friendship_send_request = current_user.create_friendship(params[:friend2_id])
    if @friendship_send_request.save
      flash[:notice] = 'Invitation sent successfully'
    else
      flash[:alert] = 'Something went wrong'
    end
    redirect_to users_path
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @friend = User.find(params[:id])
    @friendship = @user.find_received(@friend.id)
    @friendship.confirm_friend(@user,@friend)
    if @friendship.save
      flash[:notice] = 'You accepted the invitation'
      redirect_to user_friends_path
    else
      flash[:notice] = 'Something went wrong'
    end
  end

  def destroy
    if params[:user][:operation] == 'receive'
      @friendship = current_user.find_received(params[:user][:id])
      @friendship.destroy
      destroy_friendship(@friendship, 'You declined the invitation')
    elsif params[:user][:operation] == 'send'
      @friendship = current_user.find_sent(params[:user][:friend2_id])
      @friendship.destroy
      destroy_friendship(@friendship, 'You canceled the invitation')
    else
      @friend = User.find(params[:user][:friend_id])
      current_user.delete_mutual_friendship(@friend)
      flash[:alert] = 'Unfriended Successfully'
      redirect_to request.referrer
    end
  end
end

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
    @friendship_send_request = current_user.friendships.create(friend_id: params[:friend2_id], confirmed: false)
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
    @user.confirm_friend(@friend)
    @friendship = @user.inverse_friendships.find { |friendship| friendship.user == @friend }
    if @friendship.save
      flash[:notice] = 'You accepted the invitation'
      redirect_to user_friends_path
    else
      flash[:notice] = 'Something went wrong'
    end
  end

  def destroy
    if params[:user][:operation] == 'receive'
      @friendship = current_user.inverse_friendships.where(confirmed: false).find_by(user_id: params[:user][:id])
      @friendship.destroy
      destroy_friendship(@friendship, 'You declined the invitation')
    elsif params[:user][:operation] == 'send'
      @friendship = current_user.friendships.where(confirmed: false).find_by(friend_id: params[:user][:friend2_id])
      @friendship.destroy
      destroy_friendship(@friendship, 'You canceled the invitation')
    else
      @friendship = Friendship.find(params[:id])
      @friendship.destroy
      flash[:alert] = 'Unfriended Successfully'
      redirect_to request.referrer
    end
  end
end

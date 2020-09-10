class FriendshipsController < ApplicationController
  def index
    @user = current_user
  end
    
  def new
    @friendship = Friendship.new
  end

  def create
    @friendship_send_request = current_user.friendships_as_requester.create(friend2_id: params[:friend2_id], status: false)
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
    @friendship = @user.friendships_as_receiver.find(params[:id])
    @friendship.update(status: true)
    if @friendship.save
      flash[:notice] = 'You accepted the invitation'
      render :index
    else
      flash[:notice] = 'Something went wrong'
    end
  end

  def destroy
    if params.has_value?('receive')
      @friendship = current_user.friendships_as_receiver.find(params[:id])
      @friendship.destroy
      if @friendship.save
        flash[:alert] = 'You declined the invitation'
        render :index
      else
        flash[:notice] = 'Something went wrong'
      end
    elsif params.has_value?('send')
      @friendship = current_user.friendships_as_requester.find_by(friend1_id: current_user.id, friend2_id: params[:id])
      friend = @friendship.friend2_id
      @friendship.destroy
      if @friendship
        flash[:notice] = 'Something went wrong'
      else
        flash[:alert] = 'You declined the invitation'
        redirect_to user_path(friend)
      end
    end
  end
 end

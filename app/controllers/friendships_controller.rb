class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  
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
    if params[:friendship][:operation].eql?('receive')
      @friendship = current_user.friendships_as_receiver.find(params[:id])
      @friendship.destroy
      if @friendship.destroy()
        flash[:alert] = 'You declined the invitation'
        redirect_to request.referrer
      else
        flash[:notice] = 'Something went wrong'
      end
    elsif params[:friendship][:operation].eql?('send') 
      @friendship = current_user.friendships_as_requester.find_by(friend1_id: current_user.id, friend2_id: params[:friendship][:friend2_id])
      @friendship.destroy
      if @friendship.destroy()
        flash[:alert] = 'You canceled the invitation'
        redirect_to request.referrer 
      else
        flash[:notice] = 'Something went wrong'
      end
    else
      @friendship = Friendship.find(params[:id])
      @friendship.destroy
      flash[:alert] = 'Unfriended Successfully'
      redirect_to request.referrer
    end
  end
end

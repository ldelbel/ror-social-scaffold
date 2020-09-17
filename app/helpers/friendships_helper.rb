module FriendshipsHelper
  def destroy_friendship(friendship, message)
    if friendship.destroy
      flash[:alert] = message
      redirect_to request.referrer
    else
      flash[:notice] = 'Something went wrong'
    end
  end
end

class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @current_user = current_user
  end

  def show
    @current_user = current_user
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end
end

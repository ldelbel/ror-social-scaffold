class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_user = current_user
    @users = User.all.where.not(id: @current_user.id)
  end

  def show
    @current_user = current_user
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end
end

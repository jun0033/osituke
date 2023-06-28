class Public::RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:user_id])
    @user = User.find(params[:user_id])
    @user.create_notification_follow(current_user)
  end

  def destroy
    current_user.unfollow(params[:user_id])
    @user = User.find(params[:user_id])
  end

  def active_follow
    user   = User.find(params[:user_id])
    @users = user.active_follows.page(params[:page])
  end

  def passive_follow
    user   = User.find(params[:user_id])
    @users = user.passive_follows.page(params[:page])
  end
end

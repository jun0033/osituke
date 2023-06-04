class Public::RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def active_follow
    user = User.find(params[:user_id])
    @users = user.active_follows
  end

  def passive_follow
    user = User.find(params[:user_id])
    @users = user.passive_follows
  end
end

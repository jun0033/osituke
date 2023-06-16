class Public::FavoritesController < ApplicationController
  def create
    @hobby = Hobby.find(params[:hobby_id])
    @favorite = current_user.favorites.new(hobby_id: @hobby.id)
    # 趣味の投稿主に通知を発行
    @favorite.create_notification_favorite(current_user)
    @favorite.save
  end

  def destroy
    @hobby = Hobby.find(params[:hobby_id])
    @favorite = current_user.favorites.find_by(hobby_id: @hobby.id)
    @favorite.destroy
  end

  def index
    @user = User.find(params[:id])
    @favorites = Favorite.where(user_id: @user.id)
    @hobbies = Hobby.where(id: @favorites.pluck(:hobby_id)).page(params[:page])
  end
end

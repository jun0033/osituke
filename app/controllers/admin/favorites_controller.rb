class Admin::FavoritesController < ApplicationController
  def index
    @user = User.find(params[:id])
    @favorites = Favorite.where(user_id: @user.id)
    @hobbies = Hobby.where(id: @favorites.pluck(:hobby_id))
  end
end

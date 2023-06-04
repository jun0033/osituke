class Public::FavoritesController < ApplicationController
  def create
    @hobby = Hobby.find(params[:hobby_id])
    favorite = current_user.favorites.new(hobby_id: @hobby.id)
    favorite.save
  end

  def destroy
    @hobby = Hobby.find(params[:hobby_id])
    favorite = current_user.favorites.find_by(hobby_id: @hobby.id)
    favorite.destroy
  end
end

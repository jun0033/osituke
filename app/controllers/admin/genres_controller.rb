class Admin::GenresController < ApplicationController
  def create
    @genre = Genre.new(genre_params)
    @genre.save
    redirect_to request.referer
  end

  def index
    @genres = Genre.all.page(params[:page]).per(50)
  end

  def show
    genre = Genre.includes(:hobbies).find(params[:id])
    @hobbies = genre.hobbies.order(id: :desc).page(params[:page])
  end

  def destroy
    genre = Genre.find(params[:id])
    genre.destroy
    redirect_to request.referer
  end

  private

  def genre_params
    params.require(:genre).permit(:genre_name)
  end
end

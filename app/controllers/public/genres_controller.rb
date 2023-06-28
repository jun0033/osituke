class Public::GenresController < ApplicationController
  def index
    @genres = Genre.all.page(params[:page]).per(50)
  end

  def show
    @genre = Genre.includes(:hobbies).find(params[:id])
    user   = User.where(user_status: false)
    # ユーザーステータスが有効のデータのみ表示
    @hobbies = @genre.hobbies.order(id: :desc).where(user_id: user.pluck(:id)).page(params[:page])
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      render :create
    else
      render :error
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:genre_name)
  end
end

class Public::HobbiesController < ApplicationController
  def show
    @hobby = Hobby.find(params[:id])
    @user = @hobby.user
  end

  def new
    @hobby = Hobby.new
    @tag = Tag.new
    @tags = Tag.all
  end

  def create
    @hobby = Hobby.new(hobby_params)
    @user = current_user
    if @hobby.save
      redirect_to root_path
      flash[:notice] = "#{@hobby.title}が誰かの元へ飛んでいきました"
    else
      flash[:alert] = "押し付けに失敗しました"
      redirect_to user_path(current_user)
    end
  end

  def index
  end

  def edit
  end

  def destroy
    @hobby = Hobby.find(params[:id])
    @hobby.delete
    redirect_to user_path(current_user)
  end

  private

  def hobby_params
    # 画像をハッシュで保存
    params.require(:hobby).permit(:title, :body, :tag_id, :user_id, hobby_images:[])
  end
end

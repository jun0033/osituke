class Public::TagsController < ApplicationController
  def index
    @tags = Tag.all.page(params[:page]).per(50)
  end

  def show
    tag = Tag.find(params[:id])
    user = User.where(user_status: false)
    @hobbies = tag.hobbies.order(id: :desc).where(user_id: user.pluck(:id)).page(params[:page])
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render :create
    else
      render :error
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:tag_name)
  end
end

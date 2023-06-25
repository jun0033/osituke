class Admin::TagsController < ApplicationController
  def create
    @tag = Tag.new(tag_params)
    @tag.save
    redirect_to request.referer
  end

  def index
    @tags = Tag.all.page(params[:page]).per(50)
  end

  def show
    @tag = Tag.find(params[:id])
    @hobbies = @tag.hobbies.order(id: :desc).where(is_draft: false).page(params[:page])
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    redirect_to request.referer
  end

  private

  def tag_params
    params.require(:tag).permit(:tag_name)
  end
end

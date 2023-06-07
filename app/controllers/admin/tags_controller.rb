class Admin::TagsController < ApplicationController
  def create
    @tag = Tag.new(tag_params)
    @tag.save
    redirect_to request.referer
  end

  def index
    @tags = Tag.all
  end

  def show
    tag = Tag.find(params[:id])
    @hobbies = tag.hobbies
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.delete
    redirect_to request.referer
  end

  private

  def tag_params
    params.require(:tag).permit(:tag_name)
  end
end

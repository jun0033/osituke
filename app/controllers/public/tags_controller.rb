class Public::TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    tag = Tag.find(params[:id])
    @hobbies = tag.hobbies
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

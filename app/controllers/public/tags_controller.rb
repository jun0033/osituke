class Public::TagsController < ApplicationController
  def index
    @tags = Tag.all.page(params[:page]).per(50)
  end

  def show
    begin
      @tag = Tag.find(params[:id])
      user = User.where(user_status: false)
      @hobbies = @tag.hobbies.order(id: :desc).where(user_id: user.pluck(:id)).where(is_draft: false).page(params[:page])
    rescue
      redirect_to hobbies_path
      flash[:danger] = "タグが見つかりませんでした"
    end
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

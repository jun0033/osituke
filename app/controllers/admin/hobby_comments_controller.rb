class Admin::HobbyCommentsController < ApplicationController
  def index
    @user     = User.find(params[:id])
    @comments = HobbyComment.where(user_id: @user.id).page(params[:page])
  end

  def destroy
    @comment = HobbyComment.find(params[:id])
    @comment.destroy
    flash[:warning] = 'コメントを削除しました'
    redirect_to request.referer
  end
end

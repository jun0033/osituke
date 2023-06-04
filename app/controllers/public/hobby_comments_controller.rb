class Public::HobbyCommentsController < ApplicationController
  def index
  end

  def create
    @comment = HobbyComment.new(params[:id])
    if @comment.save
      redirect_to request.referer
      flash[:notice] = "コメントを送信しました"
    else
      flash[:alert] = "コメントの送信に失敗しました"
      redirect_to request.referer
    end
  end

  private

  def hobby_params
    params.require(:hobby).permit(:comment)
  end
end

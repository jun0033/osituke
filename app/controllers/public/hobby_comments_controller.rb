class Public::HobbyCommentsController < ApplicationController
  def index
  end

  def create
    @comment = HobbyComment.new(comment_params)
    if @comment.save
      redirect_to request.referer
      flash[:notice] = "コメントを送信しました"
    else
      redirect_to request.referer
      flash[:alert] = "コメントの送信に失敗しました"
    end
  end

  private

  def comment_params
    params.require(:hobby_comment).permit(:comment, :hobby_id, :user_id)
  end
end

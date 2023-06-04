class Public::HobbyCommentsController < ApplicationController
  def index
  end

  def create
    @comment = HobbyComment.new(comment_params)
    @hobby = @comment.hobby
    @user = @hobby.user
    if @comment.save
      redirect_to user_hobby_path(@user, @hobby)
      flash[:notice] = "コメントを送信しました"
    else
      render 'public/hobbies/show'
      flash.now[:alert] = "コメントの送信に失敗しました"
    end
  end
  
  def destroy
    @comment = HobbyComment.find(params[:id])
    @comment.delete
    redirect_to request.referer
  end

  private

  def comment_params
    params.require(:hobby_comment).permit(:comment, :hobby_id, :user_id)
  end
end

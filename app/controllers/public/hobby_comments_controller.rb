class Public::HobbyCommentsController < ApplicationController
  def index
    @user = User.find(params[:id])
    @comments = HobbyComment.order(id: :desc).where(user_id: @user.id).page(params[:page])
  end

  def create
    @hobby = Hobby.find(params[:hobby_id])
    @comment = @hobby.hobby_comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      @comment.create_notification_comment(current_user, @hobby.id)
      redirect_to hobby_path(@hobby)
      flash[:notice] = "コメントを送信しました"
    else
      render 'public/hobbies/show'
      flash.now[:alert] = "コメントの送信に失敗しました"
    end
  end

  def report
    @hobby = Hobby.find(params[:hobby_id])
    @comment = @hobby.hobby_comments.new(comment_params)
    @comment.done_status = true
    @comment.user_id = current_user.id
    if @comment.save
      @comment.create_notification_comment(current_user, @hobby.id)
      redirect_to hobby_path(@hobby)
      flash[:notice] = "コメントを送信しました"
    else
      render 'public/hobbies/show'
      flash.now[:alert] = "コメントの送信に失敗しました"
    end
  end

  def destroy
    @comment = HobbyComment.find(params[:id])
    @comment.destroy
    redirect_to request.referer
  end

  private

  def comment_params
    params.require(:hobby_comment).permit(:comment, :star, :done_status)
  end
end

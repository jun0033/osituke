class Public::ToDoesController < ApplicationController
  def create
    @hobby = Hobby.find(params[:hobby_id])
    @to_does = current_user.to_does.new(hobby_id: @hobby.id)
    @to_does.save
  end

  def destroy
    @hobby = Hobby.find(params[:hobby_id])
    @to_does = current_user.to_does.find_by(hobby_id: @hobby.id)
    @to_does.destroy
  end

  def index
    @user = User.find(params[:id])
    to_does = ToDo.where(user_id: @user.id)
    comment = HobbyComment.where(user_id: @user.id).where(done_status: true)
    # 完了報告を既にしている投稿を排除しユーザーのToDoを
    @hobbies = Hobby.where(id: to_does.pluck(:hobby_id)).where.not(id: comment.pluck(:hobby_id))
  end
end
